+++
date = "2019-04-23T00:09:26-07:00"
title = "Challenge Accepted: Transposit"
author = "Jessica Frazelle"
description = "On converting one of my bots to transposit."
+++

Last week, I had the pleasure of meeting with the [Transposit](https://www.transposit.com/)
team in San Francisco. Tech is a super small world and it turns out the two
founders and I are separated by one-degree through several different people
we know. In meeting them I closed many loops without even realizing it, but
I digress...

Their product is really cool, it exposes a SQL interface for interacting with
numerous APIs at once. For someone like myself who deploys a lot of bots, this
is great. Usually when I have a complex bot I end up writing a lot of
"glue code" to combine a few different APIs and get the information I want.
Most of my bots have some sort of pagination logic and all have the `N+1` problem where
I don't really optimize my queries or use anything fancy like graphQL. Many
APIs don't even have graphQL interfaces but also I am old school and I don't
really want to learn something new. This is why I was super intrigued by
Transposit's SQL interface, because hey, I know SQL!

Adam, the CEO, challenged me to try it out, give them feedback, and see if
I could break it with something complex. I am not one to back down from
a challenge and I have some super weird ass bots, so I decided to start with
the weirdest.

## Gitable

[Gitable](https://github.com/jessfraz/gitable) is a bot I made for sending all
my open issues and PRs on GitHub to a table in [Airtable](https://airtable.com/).
I fucking love Airtable. It's design just feels right and works the way my
brain works. 

I set out to make this bot work in Transposit because I know it has some
super weird loops and has the `N+1` problem where I loop over all my repos,
then make another API call after.

To reiterate, the goal of the bot is to iterate through all my repos on GitHub
and sync the list of issue and PRs with a table in Airtable.

### Query all the user's repos

First, I need to get all my repos that are not forks. So I need
a SQL query for this, in Transposit it looks like this:

```sql
SELECT name, full_name FROM github.list_repos_for_user
WHERE username=@owner
AND type='owner'
AND fork=false
```

The `github.list_repos_for_user` table is a built in to Transposit and they
handle all your API keys and authorizations when you choose "Github" as a data
connection in the UI. It also caches the response which is a huge win because
I am the queen of being rate limited.

I named that query: `list_repos_for_user` so when I want to use it elsewhere in
another query, I can call it by `this.list_repos_for_user`.

### Query all the issues in all the user's repos

To get all the issues in all my repos I can use a join on that table I just
created. It ends up looking like this:

```sql
SELECT 
    A.created_at AS created, 
    A.updated_at AS updated, 
    B.full_name, A.number, 
    A.html_url AS url, 
    A.state, A.title, 
    A.user.login AS author, 
    A.labels, B.name,
    A.closed_at AS completed, 
    A.comments
FROM github.list_issues_for_repo
AS A 
JOIN this.list_repos_for_user 
AS B 
ON A.repo = B.name
WHERE A.owner=@owner
AND B.owner=@owner
```

Okay so I didn't break anything yet and I just joined my table with all my
repos, `this.list_repos_for_user`, with the built-in table in Trasnposit
`github.list_issues_for_repo`. This has now replaced my `N+1` code with just this
one SQL query and Transposit does all the optimizations on their end.

I called this table `list_issues_for_user` and `@owner` is a parameter, so
anyone else can fork this app and change it to their own username.

### Query all the records in an Airtable table

Now I need to get all the existing airtable records in my table so I can know
later on down the road if I need to create a row or update a row with the new
information from the GitHub API.

In my Airtable table I have a column called "reference" which stores information
about the issue or PR as `owner/repo#num` so for example it looks like
`jessfraz/.vim#1`. This is a column defined by me, but I also know it to be
unique. So I want to get the reference of every column and it's airtable record
ID so I can use that to update the record.

```sql
SELECT id, fields.Reference as reference FROM airtable.get_records
WHERE baseId=@baseID
AND table=@table
```

That winds up looking like the query above. `@baseID` and `@table` are
parameters so anyone can replace those with their own for their table in
Airtable.

I named this query `get_airtable_records` so when I call it later I can do so
with `this.get_airtable_records`.


### Update and create rows in Airtable for each of the issues in user's repos

Okay so now's the part where I am thinking... I'm going to break this thing.
(Narrator: I didn't.)

Transposit has both SQL and Javascript operations and since the next part was
where a lot of the logic was I used Javascript. I haven't written Javascript in
a long time so mind my shitty code. Honestly, SQL is turing complete so
I considered using SQL but I wanted to get this done in an hour. (I will leave
it as an exercise for the reader to fork my app and make it all in SQL.)

What I needed to do was take our earlier table to `list_issues_for_user`,
iterate over them, and update or create an Airtable record for each of them.
This ends up looking like the following:

```js
function run(params) {
    var results = api.run("this.list_issues_for_user", {owner: params.owner});

    for (var i = 0; i < results.length; i++) {   
        // Build the reference for the issue with the full name and number.
        // Winds up looking like "jessfraz/.vim#1"
        var reference = results[i].full_name + "#" + results[i].number;

        // Get the Airtable recordID for the reference if it exists.
        var id = api.query("select id from this.get_airtable_records where reference='"+reference+"'", {baseID: params.baseID, table: params.table});

        // Define the object params for create and update.
        var obj = {
            baseID: params.baseID, 
            table: params.table,
            reference: reference,
            title: results[i].title,
            state: results[i].state,
            author: results[i].author,
            type: 'issue',
            comments: results[i].comments,
            url: results[i].url,
            updated: results[i].updated,
            created: results[i].created,
            completed: results[i].completed,
            repo: results[i].name,
        };

        if (id.length > 0) {
            results[i].airtable_id = id[0].id;
            obj.recordID = id[0].id;

            // Update the result in the table.
            var r = api.run("this.update_record", obj);
            api.log(r);
        } else {
            // Create record in the table.
            results[i].airtable_id = 0;
            var r = api.run("this.create_record", obj);
            api.log(r);
        }
        
        results[i].reference = reference;
    }
    return {
        results
    };
}
```

You might be wondering what `this.create_record` and `this.update_record` look
like. These are just helper operations so I can use all the fields for the
records as parameters.

### Create an Airtable record

`create_record` calls the built-in `airtable.create_record` which looks like
the following:

```sql
SELECT * FROM airtable.create_record
AND baseId=@baseID
AND table=@table
AND $body=(SELECT {
    'fields' : { 
        'Reference':  @reference,
        'Title':      @title,
        'State':      @state,
        'Author':     @author,
        'Type':       @type,
        'Comments':   @comments,
        'URL':        @url,
        'Updated':    @updated,
        'Created':    @created,
        'Completed':  @completed,
        'Repository': @repo, 
    }
})
```

Everything starting with an `@` is a parameter we can change on the fly in our
Javascript function like you saw above.


### Update an Airtable record

`update_record` is very similar, it calls the Transposit built-in
`airtable.update_record`:

```sql
SELECT * FROM airtable.update_record
WHERE recordId=@recordID
AND baseId=@baseID
AND table=@table
AND $body=(SELECT {
    'fields' : { 
        'Reference':  @reference,
        'Title':      @title,
        'State':      @state,
        'Author':     @author,
        'Type':       @type,
        'Comments':   @comments,
        'URL':        @url,
        'Updated':    @updated,
        'Created':    @created,
        'Completed':  @completed,
        'Repository': @repo, 
    }
})
```

Doing the above with pull requests rather than issues is the exact same code 
but you swap out the query for issues with pull requests. 
You can schedule your operations to run at certain times like cron or when you call an API endpoint.

Sadly, I failed at breaking the thing with one of my most complex bots. But
maybe you will have better luck trying ;) You can fork my app or look at the
queries here:
[console.transposit.com/t/jessfraz/gitable](https://console.transposit.com/t/jessfraz/gitable).
