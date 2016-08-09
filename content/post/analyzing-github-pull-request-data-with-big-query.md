+++
date = "2016-08-07T08:09:26-07:00"
title = "Analyzing GitHub Pull Request Data with BigQuery"
author = "Jessica Frazelle"
description = "Analyzing GitHub Pull Request Data with Google BigQuery."
+++

I really enjoyed [Felipe Hoffa’s post on Analyzing GitHub issues and comments with BigQuery
](https://medium.com/google-cloud/analyzing-github-issues-and-comments-with-bigquery-c41410d3308#.x5qyw8yd9).

Which got me wondering about my favorite subject ever, [The Art of Closing](https://blog.jessfraz.com/post/the-art-of-closing/). I wonder what the stats are for the top 15 projects on GitHub in terms of pull requests opened vs. pull requests closed. This post will use the [GitHub Archive dataset](http://www.githubarchive.org/).

### Top 15 repositories with the most pull requests

First let’s find the **top 15 repos with the most pull requests from 2015**. Let’s make sure to check the payload action is ”opened”.

```
SELECT
  repo.name,
  COUNT(*) c
FROM
  [githubarchive:year.2015]
WHERE
  type IN ( 'PullRequestEvent')
  AND JSON_EXTRACT(payload, '$.action') IN ('"opened"')
GROUP BY
  repo.name
ORDER BY
  c DESC
LIMIT
  15
```

| repo_name                      | c     |
|--------------------------------|-------|
| openmicroscopy/snoopys-sandbox | 11656 |
| brianchandotcom/liferay-portal | 10803 |
| Homebrew/homebrew              | 9519  |
| caskroom/homebrew-cask         | 6833  |
| apache/spark                   | 6667  |
| saltstack/salt                 | 6636  |
| mozilla-b2g/gaia               | 6609  |
| jlord/patchwork                | 6155  |
| GoogleCloudPlatform/kubernetes | 5937  |
| jsdelivr/jsdelivr              | 5747  |
| rust-lang/rust                 | 5559  |
| cms-sw/cmssw                   | 5507  |
| code-dot-org/code-dot-org      | 5267  |
| docker/docker                  | 5083  |
| NixOS/nixpkgs                  | 4873  |


Okay that’s a lot of pull requests. Let’s find the projects will the **most unique number of pull request authors**.

```
SELECT
  repo.name,
  COUNT(*) c,
  COUNT(DISTINCT actor.id) authors,
FROM
  [githubarchive:year.2015]
WHERE
  type IN ( 'PullRequestEvent')
  AND JSON_EXTRACT(payload, '$.action') IN ('"opened"')
GROUP BY
  repo.name
ORDER BY
  authors DESC
LIMIT
  15
```

| repo_name                         | c    | authors |
|-----------------------------------|------|---------|
| jlord/patchwork                   | 6155 | 5396    |
| octocat/Spoon-Knife               | 3966 | 3741    |
| deadlyvipers/dojo_rules           | 4847 | 3076    |
| Homebrew/homebrew                 | 9519 | 2186    |
| udacity/create-your-own-adventure | 2709 | 2167    |
| caskroom/homebrew-cask            | 6833 | 1517    |
| borisyankov/DefinitelyTyped       | 2694 | 1127    |
| rails/rails                       | 3100 | 1012    |
| LarryMad/recipes                  | 1086 | 989     |
| laravel/framework                 | 2736 | 891     |
| docker/docker                     | 5083 | 882     |
| rdpeng/ProgrammingAssignment2     | 922  | 866     |
| apache/spark                      | 6667 | 851     |
| JetBrains/swot                    | 951  | 836     |
| rust-lang/rust                    | 5559 | 835     |


Now let’s see what the **merge vs. close** numbers look like for those projects.

```
SELECT
  repo.name,
  COUNT(*) c,
  COUNT(DISTINCT actor.id) authors,
  SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN 1 ELSE 0 END) AS merged,
  SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('false') THEN 1 ELSE 0 END) AS closed,
FROM
  [githubarchive:year.2015]
WHERE
  type IN ( 'PullRequestEvent')
  AND JSON_EXTRACT(payload, '$.action') IN ('"closed"')
GROUP BY
  repo.name
ORDER BY
  authors DESC
LIMIT
  15
```

| repo_name                         | c    | authors | merged | closed |
|-----------------------------------|------|---------|--------|--------|
| deadlyvipers/dojo_rules           | 1636 | 1022    | 0      | 1636   |
| octocat/Spoon-Knife               | 1103 | 944     | 0      | 1103   |
| jlord/patchwork                   | 6595 | 705     | 4905   | 1690   |
| LarryMad/recipes                  | 588  | 532     | 0      | 588    |
| apache/spark                      | 6653 | 468     | 0      | 6653   |
| Homebrew/homebrew                 | 9548 | 451     | 5      | 9543   |
| udacity/create-your-own-adventure | 2765 | 301     | 1946   | 819    |
| rdpeng/ProgrammingAssignment2     | 341  | 284     | 0      | 341    |
| docker/docker                     | 5250 | 254     | 3979   | 1271   |
| NixOS/nixpkgs                     | 4707 | 249     | 3438   | 1269   |
| odoo/odoo                         | 3412 | 233     | 712    | 2700   |
| borisyankov/DefinitelyTyped       | 2529 | 221     | 2173   | 356    |
| mozilla-b2g/gaia                  | 7197 | 215     | 5251   | 1946   |
| rails/rails                       | 3254 | 212     | 2090   | 1164   |
| caskroom/homebrew-cask            | 6928 | 210     | 3044   | 3884   |

Oh that is super weird. After looking into a few of the repos with 0 merged, it seems they aren’t really using GitHub for merges.

### Calculating the merge ratio

So let’s exclude those and try again, this time we can even calculate the merge ratio.

```
SELECT
  repo.name,
  COUNT(*) c,
  COUNT(DISTINCT actor.id) authors,
  SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN 1 ELSE 0 END) AS merged,
  SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('false') THEN 1 ELSE 0 END) AS closed,
  ROUND(100*SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN 1 ELSE 0 END)/COUNT(*),2) AS merge_ratio
FROM
  [githubarchive:year.2015]
WHERE
  type IN ( 'PullRequestEvent')
  AND JSON_EXTRACT(payload, '$.action') IN ('"closed"')
GROUP BY
  repo.name
HAVING
  merged > 10
ORDER BY
  authors DESC
LIMIT
  15
```

| repo_name                                     | c    | authors | merged | closed | merge_ratio |
|-----------------------------------------------|------|---------|--------|--------|-------------|
| jlord/patchwork                               | 6595 | 705     | 4905   | 1690   | 74.37       |
| udacity/create-your-own-adventure             | 2765 | 301     | 1946   | 819    | 70.38       |
| docker/docker                                 | 5250 | 254     | 3979   | 1271   | 75.79       |
| NixOS/nixpkgs                                 | 4707 | 249     | 3438   | 1269   | 73.04       |
| odoo/odoo                                     | 3412 | 233     | 712    | 2700   | 20.87       |
| borisyankov/DefinitelyTyped                   | 2529 | 221     | 2173   | 356    | 85.92       |
| mozilla-b2g/gaia                              | 7197 | 215     | 5251   | 1946   | 72.96       |
| rails/rails                                   | 3254 | 212     | 2090   | 1164   | 64.23       |
| caskroom/homebrew-cask                        | 6928 | 210     | 3044   | 3884   | 43.94       |
| cms-sw/cmssw                                  | 5475 | 205     | 4312   | 1163   | 78.76       |
| symfony/symfony                               | 2587 | 185     | 1387   | 1200   | 53.61       |
| facebook/react-native                         | 1563 | 185     | 494    | 1069   | 31.61       |
| robbyrussell/oh-my-zsh                        | 731  | 185     | 307    | 424    | 42.0        |
| githubteacher/github-for-developers-sept-2015 | 404  | 181     | 301    | 103    | 74.5        |
| nightscout/cgm-remote-monitor                 | 1096 | 178     | 419    | 677    | 38.23       |

### Using the diff data

Sweet now let’s see on average what the size of the diffs are for these projects' pull requests.

```
SELECT
  repo.name,
  COUNT(*) c,
  COUNT(DISTINCT actor.id) authors,
  SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN 1 ELSE 0 END) AS merged,
  SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('false') THEN 1 ELSE 0 END) AS closed,
  ROUND(100*SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN 1 ELSE 0 END)/COUNT(*),2) AS merge_ratio,
  AVG(JSON_EXTRACT(payload, '$.pull_request.additions')) AS avg_additions,
  AVG(JSON_EXTRACT(payload, '$.pull_request.deletions')) AS avg_deletions,
  AVG(JSON_EXTRACT(payload, '$.pull_request.changed_files')) AS avg_changed_files,
FROM
  [githubarchive:year.2015]
WHERE
  type IN ( 'PullRequestEvent')
  AND JSON_EXTRACT(payload, '$.action') IN ('"closed"')
GROUP BY
  repo.name
HAVING
  merged > 10
ORDER BY
  authors DESC
LIMIT
  15
```

| repo_name                                     | c    | authors | merged | closed | merge_ratio | avg_additions      | avg_deletions      | avg_changed_files  |
|-----------------------------------------------|------|---------|--------|--------|-------------|--------------------|--------------------|--------------------|
| jlord/patchwork                               | 6595 | 705     | 4905   | 1690   | 74.37       | 47.45595147839272  | 172.14268385140258 | 175.20257771038666 |
| udacity/create-your-own-adventure             | 2765 | 301     | 1946   | 819    | 70.38       | 30.39746835443038  | 13.116455696202532 | 6.742133815551537  |
| docker/docker                                 | 5250 | 254     | 3979   | 1271   | 75.79       | 214.36685714285716 | 115.88342857142857 | 8.139619047619048  |
| NixOS/nixpkgs                                 | 4707 | 249     | 3438   | 1269   | 73.04       | 339.9751434034417  | 40.72678988740174  | 5.380072232844699  |
| odoo/odoo                                     | 3412 | 233     | 712    | 2700   | 20.87       | 1626.0741500586166 | 1907.4182297772568 | 128.01992966002345 |
| borisyankov/DefinitelyTyped                   | 2529 | 221     | 2173   | 356    | 85.92       | 887.0581257413997  | 864.4827995255041  | 2.8730723606168445 |
| mozilla-b2g/gaia                              | 7197 | 215     | 5251   | 1946   | 72.96       | 415.85396693066554 | 138.59233013755733 | 10.55578713352786  |
| rails/rails                                   | 3254 | 212     | 2090   | 1164   | 64.23       | 54.88414259373079  | 29.18561770129072  | 6.880762138905962  |
| caskroom/homebrew-cask                        | 6928 | 210     | 3044   | 3884   | 43.94       | 8.448469976905312  | 4.0329099307159355 | 3.315675519630485  |
| cms-sw/cmssw                                  | 5475 | 205     | 4312   | 1163   | 78.76       | 2160.7702283105023 | 713.1713242009132  | 37.51086757990868  |
| facebook/react-native                         | 1563 | 185     | 494    | 1069   | 31.61       | 189.86756238003838 | 86.54638515674984  | 10.595649392194497 |
| robbyrussell/oh-my-zsh                        | 731  | 185     | 307    | 424    | 42.0        | 54.0328317373461   | 11.285909712722297 | 1.987688098495212  |
| symfony/symfony                               | 2587 | 185     | 1387   | 1200   | 53.61       | 142.36722071897952 | 168.96366447622728 | 28.32006184770004  |
| githubteacher/github-for-developers-sept-2015 | 404  | 181     | 301    | 103    | 74.5        | 18.217821782178216 | 0.7574257425742574 | 2.517326732673267  |
| nightscout/cgm-remote-monitor                 | 1096 | 178     | 419    | 677    | 38.23       | 519.7043795620438  | 246.9434306569343  | 8.777372262773723  |



Well that's not all that interesting...

### Can we prove you should always keep your pull requests small?

We _know_ that it is always better to make a small pull request to have it merged. Let's see if we can prove that with data!

```
SELECT
  repo.name,
  COUNT(*) c,
  COUNT(DISTINCT actor.id) authors,
  ROUND(100*SUM(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN 1 ELSE 0 END)/COUNT(*),2) AS merge_ratio,
  AVG(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN JSON_EXTRACT(payload, '$.pull_request.additions') END) AS merged_avg_additions,
  AVG(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN JSON_EXTRACT(payload, '$.pull_request.deletions') END) AS merged_avg_deletions,
  AVG(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('true') THEN JSON_EXTRACT(payload, '$.pull_request.changed_files') END) AS merged_avg_changed_files,
  AVG(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('false') THEN JSON_EXTRACT(payload, '$.pull_request.additions') END) AS closed_avg_additions,
  AVG(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('false') THEN JSON_EXTRACT(payload, '$.pull_request.deletions') END) AS closed_avg_deletions,
  AVG(CASE WHEN JSON_EXTRACT(payload, '$.pull_request.merged') IN ('false') THEN JSON_EXTRACT(payload, '$.pull_request.changed_files') END) AS closed_avg_changed_files,
FROM
  [githubarchive:year.2015]
WHERE
  type IN ( 'PullRequestEvent')
  AND JSON_EXTRACT(payload, '$.action') IN ('"closed"')
GROUP BY
  repo.name
HAVING
  merge_ratio > 5
ORDER BY
  authors DESC
LIMIT
  15
```




| repo_name                                     | c    | authors | merge_ratio | merged_avg_additions | merged_avg_deletions | merged_avg_changed_files | closed_avg_additions | closed_avg_deletions | closed_avg_changed_files |
|-----------------------------------------------|------|---------|-------------|----------------------|----------------------|--------------------------|----------------------|----------------------|--------------------------|
| jlord/patchwork                               | 6595 | 705     | 74.37       | 9.3565749235474      | 0.033231396534148826 | 1.0014271151885832       | 158.03431952662723   | 671.6674556213018    | 680.798224852071         |
| udacity/create-your-own-adventure             | 2765 | 301     | 70.38       | 7.863309352517986    | 0.6747173689619733   | 1.8144912641315518       | 83.94017094017094    | 42.67887667887668    | 18.45054945054945        |
| docker/docker                                 | 5250 | 254     | 75.79       | 176.0874591605931    | 90.80949987434029    | 5.965317919075145        | 334.2045633359559    | 194.38001573564122   | 14.946498819826909       |
| NixOS/nixpkgs                                 | 4707 | 249     | 73.04       | 137.50581733566025   | 31.841768470040723   | 2.91564863292612         | 888.5090622537431    | 64.79826635145784    | 12.056737588652481       |
| odoo/odoo                                     | 3412 | 233     | 20.87       | 200.9129213483146    | 195.0870786516854    | 7.095505617977528        | 2001.8944444444444   | 2358.966296296296    | 159.90814814814814       |
| borisyankov/DefinitelyTyped                   | 2529 | 221     | 85.92       | 390.8085595950299    | 482.45467096180397   | 2.1339162448228257       | 3916.13202247191     | 3196.3567415730336   | 7.384831460674158        |
| mozilla-b2g/gaia                              | 7197 | 215     | 72.96       | 398.6246429251571    | 86.15311369262997    | 6.51628261283565         | 462.3448098663926    | 280.09198355601234   | 21.45580678314491        |
| rails/rails                                   | 3254 | 212     | 64.23       | 23.657416267942583   | 11.615789473684211   | 2.6382775119617223       | 110.95274914089347   | 60.732817869415804   | 14.49828178694158        |
| caskroom/homebrew-cask                        | 6928 | 210     | 43.94       | 8.201708278580815    | 5.042706964520368    | 3.9244415243101183       | 8.641864057672503    | 3.241503604531411    | 2.8385684860968072       |
| cms-sw/cmssw                                  | 5475 | 205     | 78.76       | 994.2810760667903    | 619.9148886827459    | 8.133812615955472        | 6485.7067927773005   | 1058.9337919174548   | 146.43078245915734       |
| symfony/symfony                               | 2587 | 185     | 53.61       | 63.3914924297044     | 72.16582552271089    | 8.235760634462869        | 233.65               | 280.84583333333336   | 51.534166666666664       |
| facebook/react-native                         | 1563 | 185     | 31.61       | 204.29757085020242   | 88.43522267206478    | 8.024291497975709        | 183.19925163704397   | 85.67352666043031    | 11.783910196445277       |
| robbyrussell/oh-my-zsh                        | 731  | 185     | 42.0        | 49.74267100977199    | 10.824104234527688   | 1.6612377850162867       | 57.139150943396224   | 11.620283018867925   | 2.224056603773585        |
| githubteacher/github-for-developers-sept-2015 | 404  | 181     | 74.5        | 4.700996677740863    | 0.4186046511627907   | 1.1727574750830565       | 57.71844660194175    | 1.7475728155339805   | 6.446601941747573        |
| nightscout/cgm-remote-monitor                 | 1096 | 178     | 38.23       | 173.24582338902147   | 58.885441527446304   | 4.985680190930788        | 734.1299852289512    | 363.3338257016248    | 11.124076809453472       |


### IT IS PROVEN!!!


![science](/img/science.gif)
