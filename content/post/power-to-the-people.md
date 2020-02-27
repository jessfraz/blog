+++
date = "2020-02-26T08:09:26-07:00"
title = "Power to the People"
author = "Jessica Frazelle"
description = "A dissection of power efficiency and carbon footprints for data centers and cloud providers."
+++

When you upload photos to Instagram, back up your phone to “the cloud”, send an email through GMail, or save a document in a storage application like Dropbox or Google Drive, your data is being saved in a data center. These data centers are airplane hangar-sized warehouses, packed to the brim with racks of servers and cooling mechanisms. Depending on the application you are using you are likely hitting one of Facebook’s, Google’s, Amazon’s, or Microsoft’s data centers. Aside from those major players, which we will call the “hyperscalers”, many other companies run their own data centers or rent space from a colocation center to house their server racks.

Most of the hyperscalers have made massive strides to get a “carbon neutral” footprint for their data centers. Google, Amazon, and Microsoft have all pledged to decarbonize completely, however none has succeeded in completely ditching fossil fuels as of yet. If a company claims to be “carbon neutral” it means they are offsetting their use of fossil fuels with renewable energy credits, also known as RECs[^1]. A REC represents one megawatt-hour (MWh) of electricity that is generated and delivered to the electricity grid from a renewable energy resource such as solar or wind power. Essentially by purchasing RECs, “carbon neutral” companies are giving back clean energy to prevent someone else from emitting carbon. Most companies become “carbon neutral” by investing in offsets that primarily avoid emissions, such as paying folks to not cut down trees or buying RECs. These offsets do not actually remove the carbon that they are emitting.

A “net zero” company actually has to remove as much carbon as it emits. This is referred to as “net zero” since a company is still creating carbon emissions, however their emissions are equal to the amount of carbon removed. This differs from “carbon neutral” since a “carbon neutral” company takes a look at their carbon footprint and has to prevent enough other folks from emitting that much carbon, through RECs or otherwise. Whereas a “net zero” company has to find a way to remove the amount of carbon they emit.

Lastly, if a company calls themselves “carbon negative” it means they are removing more carbon than they emit each year. This should be the gold standard for how companies operate. None of the FAANG[^2] (Facebook, Apple, Amazon, Netflix and Google) today claim to be “carbon negative”, but Microsoft issued a press release stating they are going to be carbon negative by 2030[^3].

Power usage efficiency, also known as PUE, is defined as the total energy required to power a data center (including lights and cooling) divided by the energy used for compute. 1.0 would be perfect PUE since 100% of electricity consumption is used on computation. Conventional data centers have a PUE of about 2.0, while hyperscalers have gotten theirs down to about 1.2. According to a 2019 study from the Uptime Institute, which surveyed 1,600 data centers, the average PUE was 1.67[^4].

PUE as a method of measurement is a point of contention. PUE does not account for the location of a data center, which means a data center that is located in a part of the world that can benefit from free cooling from outside air will have a lower PUE than one in a very hot temperature climate. It is most ideal to measure PUE as an annual average since seasons change and affect the cooling needs of a data center over the course of a year. According to a study from the University of Leeds, "comparing a PUE value of data centres is somewhat meaningless unless it is known whether it is operating at full capacity or not.”[^5]

Google claims a PUE of 1.1 on average, yearly, for all its data centers, while individually, some are as low as 1.08[^6]. One of the actions Google has taken for lowering their PUE is using machine learning to cool data centers with inputs from local weather and other factors[^7], such as if the weather outside is cool enough they can use it without modification as free cold air. They can also predict wind farm output up to 36 hours in advance[^8]. Google took all the data they had from sensors in their facilities monitoring temperature, power, pressure, and other resources to create neural networks to predict future PUE, temperature, and pressure in their data centers. This way they can automate and recommend actions for keeping their data centers operating efficiently from the predictions[^9]. Google also sets the temperature of its data centers to 80°F, versus the usual 68-70°F, saving a lot of power for cooling. Weather local to the data center is a huge factor. For example, Google’s Singapore data center has the highest PUE and is the least efficient of its sites because Singapore is hot and humid year-round.

Wired conducted an analysis[^10] of how Google, Microsoft, and Amazon stack up when it comes to the carbon footprint of their data centers. Google claims to be “net zero” for carbon emissions[^11] and also publishes a transparency report of their PUE every year[^12]. While Microsoft claims to be “carbon negative” by 2030, they are still “carbon neutral” today[^13]. They also claim to be pursuing 100% renewable energy by 2025. 

On the other hand, Amazon is in the worst position of large tech companies when it comes to carbon footprints. As we went over above, the location of the data center matters and some Amazon regions might be greener than others due to the weather conditions in those areas or having more access to solar or wind energy[^14]. Bezos has pledged to get to “net zero” by 2040[^15]. Greenpeace seems to believe otherwise, claiming that Amazon is not dedicated to that pledge since its Virginia data centers were only at 12% renewable energy[^16]. It’s hard to know, of course, until 2040 comes and either Amazon succeeds in their pledge or doesn’t. 

In 2018, Apple claimed 100% of their energy was from renewable sources[^17]. Facebook claims they will be at 100% renewable energy by the end of 2020[^18]. While US companies have followed suit on pledging to lower their carbon footprint, Chinese Internet giants such as Baidu, Tencent, and Alibaba have not.

## What is using power in a data center?

According to a study from Procedia Environmental Sciences, 48% of power in a data center goes to equipment like servers and racks, 33% to heating, ventilation, and air conditioning (HVAC), 8% to uninterrupted power supply (UPS) losses, 3% lighting, and 10% to everything else[^19]. 

HVAC for data centers is a delicate process of making sure hot air from server exhaust doesn’t mix with cool air and raise the temperature of the entire data center. This is why most data centers have hot and cold aisles. The goal is to have the cold air flow into one side of racks while the hot air exhaust comes out the other side of the racks. Optimizing air flow throughout your racks and servers is essential for helping with HVAC efficiency.

Power comes off the grid as AC power. This can be single-phase power which has two wires, a power wire and a neutral wire, or three-phase power which has three wires, each 120 electrical degrees out of phase with each other. The key difference being that three-phase can handle higher loads than single-phase. The frequency of the power off the grid can be either 50 or 60Hz. Voltage is any of: 208, 240, 277, 400, 415, 480, or 600V[^20]. 

Since most equipment in a data center uses DC power, the AC power needs to be converted which results in power losses and wasted energy adding up to around 21-27% of power. Let’s break this down. There is a 2% loss when utility medium voltage, defined as voltage greater than 1000V and less than 100 kV, is transformed to 480VAC. There is a 6-12% loss within a centralized UPS due to conversions from AC to DC and DC back to AC. There is a 3% power loss at the power distribution unit (PDU) level due to the transformation from 480VAC to 208VAC. Standard power supplies for servers convert 208VAC to the required DC voltage resulting in a 10% loss, assuming the power supply is 90% efficient[^21]. This is all to say that power is wasted all throughout traditional data centers in transformations and conversions.

To try to lessen the amount of wasted power from conversions, some folks rely on high-voltage DC power distribution. Lawrence Berkeley National Labs conducted a study in 2008[^22] comparing the use of 380VDC power distribution for a facility to a traditional 480VAC power distribution system. The results showed that the facility using DC power eliminated multiple conversion stages to result in a 7% decrease in energy consumption compared to a typical facility with AC power distribution. However, this is rarely done at hyperscale. Hyperscalers tend to have three-phase AC to the rack, then convert to DC at the rack or server level.

## More power efficient compute

Other than RECs and using 100% renewable energy, there are other ways hyperscalers have made their data centers more power efficient. In 2011, the Open Compute Project started out of a basement lab in Facebook’s Palo Alto headquarters[^23]. Their mission was to design from a clean slate the most efficient and economical way to run compute at scale. This led to using a 480VAC[^24] electrical distribution system to reduce energy loss, removing anything in their servers that didn’t contribute to efficiency, reusing hot aisle air in winter to heat the offices and the outside air flowing into the data center, and removing the need for a central power supply. The Facebook team went ahead and installed the newly designed servers in their Prineville data center which resulted in 38% less energy to do the same work as their existing data centers. It also cost 24% less.

Let’s dive into some of the details of the Open Compute designs that allow for power efficiency. The Open Rack design[^25] includes a power bus bar with either 12VDC or 48VDC of distributed power to the nodes. The bus bar runs along the back of the rack vertically. It transmits power from the rack level power supply units (PSUs) to the servers in the rack. The bus bar allows the servers to plug in directly to the rack for power so when you are servicing an Open Rack you do not need to unplug power cords, you can just pull out the server from the front of the rack. With the Open Compute designs, network connections to servers are at the front of the rack so the technician never has to go to the back of the rack, i.e. the hot aisle.

### Redundancy

Conventional servers have PSUs in every server. The Open Rack design has centralized PSUs for the rack, which allow for N+M redundancy for the rack, the most common deployment being N+1 redundancy. This means there is an extra PSU per rack of servers. In a conventional system this would be 1+1 since there is one extra PSU in every individual server. By keeping the PSUs centralized to the rack, this results in a reduction in power converting components which increases the efficiency of the system. 

### Right-sized PSUs

Server designers tend to choose PSUs that have enough headroom to deliver power for the maximum configuration. Server vendors would rather carry a small number of power supply SKUs that are oversized, than carry a large number of power supply SKUs that are right-sized to purpose since the economies of scale prefer the former. This leads to an oversizing factor of at least 2-3 times[^26] the required capacity for conventional power supplies. In comparison, a rack-level PSU will be less oversized since it is right-sized for purpose. The hyperscalers also have the advantage of economies of scale for their hardware. The typical Open Rack compliant power supply is oversized at only 1.2 times the required capacity, if even that.

### Optimal efficiency

Every power supply has a sweet spot for load versus efficiency. 80 Plus is a certification program for PSUs to measure efficiency. There are a few different grades: Bronze, Silver, Gold, Platinum, and Titanium. The most power efficient grade of the 80 Plus standard is Titanium. The most common grade of PSU used in data centers is 80 Plus Silver, which has a maximum efficiency of 88%. This means it wastes 12% electric energy as heat at the various load levels. In comparison, the 12V and 48VDC PSUs have data showing maximum efficiencies at 95%[^27] and 98%[^28], respectively. This means the rack-level PSUs only waste between 5 and 2% of energy.

While the efficiency of the rack-level PSU is important, we still need to weigh the cost of the number of conversions being made to get the power to each server. For every unnecessary power conversion, you are paying an efficiency cost. For example with a 48VDC rack-level power supply, the server might need to convert the rack provided 48VDC to 12VDC then that 12VDC to VCORE. VCORE is the voltage supplied to the CPU, GPU, or other processing core. With Google’s 48VDC power supply, they advocate for using 48V to point of load (PoL)[^29] to deliver power to the servers. This means placing a DC-to-DC or linear power supply regulator going from the rack-level PSU to the server which would reduce the number of conversions needed to get the power to the processing cores. However, the 48V DC to DC regulators required for Google's implementation are not common and come at a premium cost. It is likely their motivation for opening the specs for the 48VDC rack is to drive more volume to those parts and drive down costs. In contrast, 12VDC to DC regulators are quite common and low cost.

#### Reading a power efficiency graph

Below is an example of a power efficiency graph for a power supply.

![efficiency-curve](/img/efficiency-curve.png)

> Source for image: https://e2e.ti.com/blogs_/b/industrial_strength/archive/2019/04/04/three-considerations-for-achieving-high-efficiency-and-reliability-in-industrial-ac-dc-power-supplies

We can see the peak of the graph is where the PSU is the most efficient. We divide the output power by the input power to calculate efficiency. The x-axis of the graph measures the load of the power supply in Watts, while the y-axis measures efficiency.

Let’s go through an example of choosing the right power supply for the load. For the example graph above if we know our peak load is 120W and idle is 60W, this power supply would be more than we need since it can handle up to 150W. At our peak load of 120W with 230VAC, this power supply would have a maximum efficiency of around 94% and a minimum efficiency at idle of around 92% with 230VAC. We now know the losses of this specific power supply and can compare it to other supplies to see if they are more efficient for our load.

### Open Compute servers without a bus bar

Not all Open Compute servers include a power bus bar. Microsoft’s Olympus servers require on AC power[^30]. The Olympus power supply has three 340W power supply modules, one for each phase, with a total maximum output of 1000W[^31]. Therefore, these power supplies assume all deployments are three-phase power. The minimum efficiency of the PSU is 89-94% depending on the load[^32]. This places the grade of the Olympus power supply around an 80 Plus Platinum[^33]. 

Like all technical decisions, using per server AC power supplies versus rack level DC is a trade-off. By having separate power supplies, different workloads can balance the power they are consuming individually rather than at a rack level. In turn though, Microsoft needs to build and manufacture multiple power supplies to ensure they are right-sized to run at maximum efficiency for each server configuration. Serviceability also requires technicians to unplug power cables and go to the back of the rack. 

At the time Microsoft made the decision to use individual AC power supplies per server, the Open Rack design was at v1 not v2 like it is today, the cost of the copper for the power bus bar was higher and the loss of efficiency to resistance was a factor. The Open Rack v1 design had an efficiency concern with the power loss due to heating the copper in the bus bar. If a rack holds 24kW of equipment, a 12VDC power bus bar must deliver 2kA of current. This requires a very thick piece of copper which has an amount of power loss that is not insignificant due to resistance in the bus bar. 

Let’s break down how to measure the relationship of power to resistance. Ohm’s law declares electric current (I) is proportional to voltage (V) and inversely proportional to resistance (R), so V=IR. To see the relationship of power to resistance, we combine Ohm’s law (V=IR) with P = IV, which translated to power (P) is the product of current (I) and voltage (V). Substituting I = V/R gives P = (V/R)V=V2/R. Then, substituting V = IR gives P = I(IR) = I2R. So P = I2R is how we can calculate the power loss due to resistance in the bus bar.

For their decision, Microsoft balanced the conversion efficiency against the material cost of the bus bar and the resistive loss. However, Open Rack v2 changes the trade-offs of their original decision. With a 48VDC bus bar, a rack that holds 24kW of equipment only requires 500A, as opposed to the 2kA required by the 12vDC power bus bar from the v1 spec. This translates into a much cheaper bus bar and lower losses due to resistance. The bus bar still has more loss than 208VAC cables but there is an improved efficiency from the power supply unit at the rack-level, which makes it compelling. However, as we stated earlier you need to be mindful of the number of conversions getting the power to the components on the motherboard. If your existing equipment is 12VDC, you would want to avoid any extra conversions using that with a 48VDC bus bar. Save the 48VDC bus bar for new equipment that has 48V to point of load to avoid any extra conversions.

The main difference between Microsoft’s design with individual power supplies and the 24VDC and 48VDC Open Rack designs is the way the initial set of power is delivered to the servers. For Microsoft’s design, they distribute three-phase power to the servers individually through power supplies while the 24VDC and 48VDC power bus bar distributes the power delivery to the servers. Once power is delivered to the server, the power is sent through typically a DC-to-DC power supply regulator which in turn powers the components on the motherboard. This step is shared whether the power is coming from a single power bus bar or individual power supplies.

There is another interesting bit that comes into play with uninterrupted power supplies (UPS). We talked a bit earlier about the losses in efficiency due to UPSes. Let’s go over a bit about what this means in terms of a DC bus bar or individual AC PSUs. When AC power is going into each individual server you have two choices: a UPS on the AC before it gets distributed to the individual servers or a UPS per server integrated into each server’s PSU. Deploying and servicing individual batteries per server is a nightmare for maintenance. Because of this, most facilities that use AC power to the servers wind up using rack-wide or building-wide UPSes. Since the batteries in a UPS are DC, an AC UPS has an AC to DC converter for charging the batteries and a DC to AC inverter to provide AC power from the battery. For online UPSes, meaning the battery is always connected, this requires two extra conversions from AC to DC and DC back to AC with power efficiency losses for both. 

With a DC rack-level design, battery packs can be attached directly to the bus bar. The rack-level PSUs are the first AC to DC conversion state so there is not a need for another conversion since everything from there runs on DC. The downside is that the rack-level PSU needs to adjust the voltage level to act as a battery charger. This means the servers need to accept a fairly wide tolerance on the 48V target, around +/-10V so 40-56V isn't unreasonable. Because DC to DC converters are fairly tolerant about input voltage ranges, this is fairly straightforward to deal with without any significant loss in power efficiency. It’s important to note that for hyperscalers UPSes are only present to allow for a generator to kick in which is a few seconds versus around 10-15 minutes for a traditional data center.

With commodity servers, like Dell[^34] or Supermicr[^35]o, the cost of individual power supplies is much higher on power efficiency since those PSUs are not as high of a grade and have much more oversizing. They also tend to lack power supply regulators that minimize power conversion losses in supplying power to the components on the board. This would lead to around an 8-12% gain in power efficiency by moving from a bunch of commodity servers in a rack to an OCP design. Not to mention, the serviceability ease of the bus bar would benefit technicians as well.

By designing rack level architectures, huge improvements can be made for power efficiency over conventional servers since PSUs will be less oversized, more consolidated, and redundant for the rack versus per server. While the hyperscalers have benefitted from these gains in power efficiency, most of the industry is still waiting. The Open Compute project was started as an effort to allow other companies running data centers to benefit from the power efficiencies as well. If more organizations run rack-scale architectures in their data centers, we can lessen the wasted carbon emissions caused by conventional servers.

Huge thanks to Rick Altherr, Amir Michael, Kenneth Finnegan, Arjen Roodselaar, and Scott Andreas for their help with the nuances in this article.

[^1]: https://www.epa.gov/greenpower/renewable-energy-certificates-recs 
[^2]: https://en.wikipedia.org/wiki/Facebook,_Apple,_Amazon,_Netflix_and_Google
[^3]: https://blogs.microsoft.com/blog/2020/01/16/microsoft-will-be-carbon-negative-by-2030/
[^4]: https://uptimeinstitute.com/resources/asset/2019-data-center-industry-survey
[^5]: http://eprints.whiterose.ac.uk/79352/1/GBrady%20Case%20Study%20of%20PUE.pdf
[^6]: https://www.google.com/about/datacenters/efficiency/
[^7]: https://deepmind.com/blog/article/safety-first-ai-autonomous-data-centre-cooling-and-industrial-control
[^8]: https://deepmind.com/blog/article/machine-learning-can-boost-value-wind-energy
[^9]: https://deepmind.com/blog/article/deepmind-ai-reduces-google-data-centre-cooling-bill-40
[^10]: https://www.wired.com/story/amazon-google-microsoft-green-clouds-and-hyperscale-data-centers/
[^11]: https://cloud.google.com/blog/topics/google-cloud-next/our-heads-in-the-cloud-but-were-keeping-the-earth-in-mind
[^12]: https://www.google.com/about/datacenters/efficiency/
[^13]: https://www.microsoft.com/en-us/corporate-responsibility/sustainability/operations
[^14]: https://aws.amazon.com/about-aws/sustainability/
[^15]: https://blog.aboutamazon.com/sustainability/the-climate-pledge
[^16]: https://www.greenpeace.org/usa/news/greenpeace-finds-amazon-breaking-commitment-to-power-cloud-with-100-renewable-energy/
[^17]: https://www.apple.com/newsroom/2018/04/apple-now-globally-powered-by-100-percent-renewable-energy/
[^18]: https://about.fb.com/news/2018/08/renewable-energy/
[^19]: https://www.sciencedirect.com/science/article/pii/S1878029617300956
[^20]: https://ctlsys.com/support/electrical_service_types_and_voltages/
[^21]: https://www.facebook.com/notes/facebook-engineering/designing-a-very-efficient-data-center/10150148003778920/
[^22]: https://eln.lbl.gov/sites/default/files/lbnl-2001006.pdf
[^23]: https://www.facebook.com/notes/facebook-engineering/building-efficient-data-centers-with-the-open-compute-project/10150144039563920/
[^24]: https://www.facebook.com/notes/facebook-engineering/designing-a-very-efficient-data-center/10150148003778920/
[^25]: https://www.opencompute.org/wiki/Open_Rack/SpecsAndDesigns
[^26]: https://blog.se.com/datacenter/2018/05/24/12v-vs-48v-the-rack-power-architecture-efficiency-calculator-illustrates-energy-savings-of-ocp-style-psus/
[^27]: https://www.opencompute.org/files/External-2018-OCP-Summit-Google-48V-Update-Flatbed-and-STC-20180321.pdf
[^28]: http://apec.dev.itswebs.com/Portals/0/APEC%202017%20Files/Plenary/APEC%20Plenary%20Google.pdf?ver=2017-04-24-091315-930&timestamp=1495563027516
[^29]: http://apec.dev.itswebs.com/Portals/0/APEC%202017%20Files/Plenary/APEC%20Plenary%20Google.pdf?ver=2017-04-24-091315-930&timestamp=1495563027516
[^30]: https://www.datacenterdynamics.com/en/news/dcd-zettastructure-why-project-olympus-relies-on-ac-power/
[^31]: http://files.opencompute.org/oc/public.php?service=files&t=2247ac812c026ea8fa15d29622779fa7&download
[^32]: http://files.opencompute.org/oc/public.php?service=files&t=2247ac812c026ea8fa15d29622779fa7&download
[^33]: https://en.wikipedia.org/wiki/80_Plus
[^34]: https://i.dell.com/sites/doccontent/shared-content/data-sheets/en/Documents/power-and-cooling-innovations_030216.pdf
[^35]: https://www.supermicro.com/en/support/resources/pws

