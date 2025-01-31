# Assignment 1: Meet the farmersmarket.db and Basic SQL

🚨 **Please review our [Assignment Submission Guide](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md)** 🚨 for detailed instructions on how to format, branch, and submit your work. Following these guidelines is crucial for your submissions to be evaluated correctly.

#### Submission Parameters:
* Submission Due Date: `January 25, 2025`
* Weight: 30% of total grade
* The branch name for your repo should be: `assignment-one`
* What to submit for this assignment:
    * This markdown (Assignment1.md) with written responses in Section 4
    * One Entity-Relationship Diagram (preferably in a pdf, jpeg, png format).
    * One .sql file 
* What the pull request link should look like for this assignment: `https://github.com/<your_github_username>/sql/pulls/<pr_id>`
    * Open a private window in your browser. Copy and paste the link to your pull request into the address bar. Make sure you can see your pull request properly. This helps the technical facilitator and learning support staff review your submission easily.

Checklist:
- [ ] Create a branch called `assignment-one`.
- [ ] Ensure that the repository is public.
- [ ] Review [the PR description guidelines](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md#guidelines-for-pull-request-descriptions) and adhere to them.
- [ ] Verify that the link is accessible in a private browser window.

If you encounter any difficulties or have questions, please don't hesitate to reach out to our team via our Slack. Our Technical Facilitators and Learning Support staff are here to help you navigate any challenges.

*** 

## Section 1:
You can start this section following *session 1*.

Steps to complete this part of the assignment:
- Load the farmersmarket.db and browse its content
- Create a logical data model

<br>
If this is your first time in DB Browser for SQLite, the following instructions may help:

#### 1) Load Database
- Open DB Browser for SQLite
- Go to File > Open Database
- Navigate to your farmersmarket.db 
	- This will be wherever you cloned the GH Repo (within the **SQL** folder)
	- ![db_browser_for_sqlite_choose_db.png](./images/01_db_browser_for_sqlite_choose_db.png)

#### 2) Configure your windows
By default, DB Browser for SQLite has three windows, with four tabs in the main window and three tabs in the bottom right window
- Window 1: Main Window (Centre)
	- Stay in the Database Structure tab for now
- Window 2: Edit Database Cell (Top Right)
- Window 3: Remote (Bottom Right)
	- Switch this to DB Schema tab (very bottom)

Your screen should look like this (or very similar)
![db_browser_for_sqlite.png](./images/01_db_browser_for_sqlite.png)

#### 3) The farmersmarket.db
There are 10 tables in the Main Window:
1) booth
2) customer
3) customer_purchases
4) market_date_info
5) product
6) product_category
7) vendor
8) vendor_booth_assignments
9) vendor_inventory
10) zip_data

Switch to the Browse Data tab, booth is selected by default

<img src="./images/01_the_browse_data_tab.png" width="900">


Using the table drop down at the top left, explore some of the contents of the database

<img src="./images/01_the_table_drop_down_at_the_top_left.png" width="200">

Move on to the Logical Data Model task when you have looked through the tables


### Build Logical Data Model

Recall during session 1:

I diagramed the following four tables:
- product
- product_category
- vendor
- vendor_inventory

 <img src="./images/01_farmers_market_logical_model_partial.png" width="500">


#### Prompt 1:
Choose two tables and create a logical data model. There are lots of tools you can do this (including drawing this by hand), but I'd recommend [Draw.io](https://www.drawio.com/) or [LucidChart](https://www.lucidchart.com/pages/). 

A logical data model must contain:
- table name
- column names
- relationship type

Please do not pick the exact same tables that I have already diagrammed. For example, you shouldn't diagram the relationship between `product` and `product_category`, but you could diagram `product` and `customer_purchases`.

**HINTS**:
- You will need to use the Browse Data tab in the main window to figure out the relationship types.
- You can't diagram tables that don't share a common column
	- These are the tables that are connected
	- <img src="./images/01_farmers_market_conceptual_model.png" width="600">
- The column names can be found in a few spots (DB Schema window in the bottom right, the Database Structure tab in the main window by expanding each table entry, at the top of the Browse Data tab in the main window)

***

## Section 2:
You can start this section following *session 2*.

Steps to complete this part of the assignment:
- Open the assignment1.sql file in DB Browser for SQLite:
	- from [Github](./02_activities/assignments/assignment1.sql)
	- or, from your local forked repository  
- Complete each question

### Write SQL

#### SELECT
1. Write a query that returns everything in the customer table.
2. Write a query that displays all of the columns and 10 rows from the customer table, sorted by customer_last_name, then customer_first_ name.

<div align="center">-</div>

#### WHERE
1. Write a query that returns all customer purchases of product IDs 4 and 9.
2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), filtered by vendor IDs between 8 and 10 (inclusive) using either:
	1.  two conditions using AND
	2.  one condition using BETWEEN

<div align="center">-</div>

#### CASE
1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. Using the product table, write a query that outputs the `product_id` and `product_name` columns and add a column called `prod_qty_type_condensed` that displays the word “unit” if the `product_qty_type` is “unit,” and otherwise displays the word “bulk.”

2. We want to flag all of the different types of pepper products that are sold at the market. Add a column to the previous query called `pepper_flag` that outputs a 1 if the product_name contains the word “pepper” (regardless of capitalization), and otherwise outputs 0.

<div align="center">-</div>

#### JOIN
1. Write a query that `INNER JOIN`s the `vendor` table to the `vendor_booth_assignments` table on the `vendor_id` field they both have in common, and sorts the result by `vendor_name`, then `market_date`.

***

## Section 3:
You can start this section following *session 3*.

Steps to complete this part of the assignment:
- Open the assignment1.sql file in DB Browser for SQLite:
	- from [Github](./02_activities/assignments/assignment1.sql)
	- or, from your local forked repository  
- Complete each question

### Write SQL

#### AGGREGATE
1. Write a query that determines how many times each vendor has rented a booth at the farmer’s market by counting the vendor booth assignments per `vendor_id`.
2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list of customers for them to give stickers to, sorted by last name, then first name.
   
**HINT**: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword.

<div align="center">-</div>

#### Temp Table
1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal
   
**HINT**: This is two total queries -- first create the table from the original, then insert the new 10th vendor. When inserting the new vendor, you need to appropriately align the columns to be inserted (there are five columns to be inserted, I've given you the details, but not the syntax)

To insert the new row use VALUES, specifying the value you want for each column:  
`VALUES(col1,col2,col3,col4,col5)`

<div align="center">-</div>

#### Date
1. Get the customer_id, month, and year (in separate columns) of every purchase in the customer_purchases table.
   
**HINT**: you might need to search for strfrtime modifers sqlite on the web to know what the modifers for month and year are!

2. Using the previous query as a base, determine how much money each customer spent in April 2022. Remember that money spent is `quantity*cost_to_customer_per_qty`.
   
**HINTS**: you will need to AGGREGATE, GROUP BY, and filter...but remember, STRFTIME returns a STRING for your WHERE statement!!

*** 

## Section 4:
You can start this section anytime.

Steps to complete this part of the assignment:
- Read the article
- Write, within this markdown file, <1000 words.

### Ethics

Read: Qadri, R. (2021, November 11). _When Databases Get to Define Family._  Wired. <br>
    https://www.wired.com/story/pakistan-digital-database-family-design/

Link if you encounter a paywall: https://web.archive.org/web/20240422105834/https://www.wired.com/story/pakistan-digital-database-family-design/

**What values systems are embedded in databases and data systems you encounter in your day-to-day life?**

Consider, for example, concepts of fariness, inequality, social structures, marginalization, intersection of technology and society, etc.


```
Your thoughts...
```
Databases are everywhere—whether in our phones, government registries, or research labs—and yet there is a persistent myth that data collection and usage are neutral acts. In truth, the choices we make in defining categories, storing personal details, and applying analytic tools are all informed by social, political, and cultural biases. As a neuroscience PhD student, I’ve become acutely aware of how these biases can seep into the most ostensibly objective research systems. However, my concern extends beyond the lab, especially after reading Rida Qadri’s Wired article on Pakistan’s digital family database. Qadri's analysis illustrates how systems intended to streamline services and improve efficiency can also entrench restrictive norms.

Qadri explains that Pakistan’s new database is framed as a tool for distributing resources and verifying identities, yet the structure of this system reveals deeply ingrained patriarchal assumptions. Women’s identities and rights risk being overshadowed by the requirement that they be documented in ways that align with male-dominated family hierarchies, demonstrating how even seemingly benign policies can replicate unequal social frameworks. This example resonates with my own observations in academia, where performance metrics—like impact factors, citation counts, and standardized evaluations—act as data-driven gateways to success. Although intended to measure achievement, these metrics elevate narrow indicators of excellence and reward competitve attitudes while downplaying collaborative or community-focused pursuits. In both contexts, a system meant to increase clarity or fairness can end up reinforcing exclusionary practices.

The illusion of objectivity in data extends into the public sphere as well. One stark example was the widespread suspicion around vote-counting systems during the 2020 U.S. election. Distrust in these technologies was amplified by misinformation campaigns that took advantage of social media algorithms. From Twitter to TikTok, digital platforms influence what information users see, prioritizing engagement (or other things... *biggest side eye to Elon*) over unbiased representation. As an American citizen, I find it deeply disturbing that complex algorithmic curation can so effectively shape political and cultural narratives, harnessing our collective uncertainty to disrupt democratic processes. These sorts of manipulations, driven by human decisions about how algorithms are designed and tuned, underscore the point that data systems are never free from bias—or from the influence of those who wield them.

My experiences in neuroscience echo these concerns. While research databases promise to illuminate links between brain function and behavior, the categories we use—sex, race, and other demographic markers—can be oversimplified or conflated, ultimately distorting results and marginalizing entire groups. Recognizing such pitfalls has prompted me to look at how other data-driven industries manage similar tensions around accessibility and control. Commercial genetic sequencing services, for instance, collect vast amounts of personal data under the appeal of revealing family ancestry or assessing health risks. Yet without rigorous oversight, this genetic information could become a trove for discrimination if exploited by racist or eugenicist political regimes. While the immediate utility of personalized genomics seems like an exciting novelty, the long-term potential for misuse illustrates how design and governance choices can either protect individual rights or facilitate new forms of oppression.

These overlapping examples also highlight issues of representation and equity, which Qadri brings to light when noting that women’s personal agency can be overshadowed by patriarchal norms in Pakistan’s family registry. In scientific research, similar patterns of exclusion emerge whenever data sets fail to capture the diversity of real-world populations. One well-known case is the nearly exclusive use of male-only animal models in pre-clinical drug development, systematically ignoring female physiology and hormonal cycles in the early stages of evaluation. As a result, medications may be designed and tested in ways that fail to account for crucial differences, leading to treatments that are less effective—or even unsafe—for women. This tendency to adopt “one-size-fits-all” data collection methods reveals a deeper value system that prioritizes convenience and cost-effectiveness over genuine inclusivity.

Ultimately, what Qadri’s reporting, my academic experiences, and recent global events all reinforce is that databases are anything but inert containers of facts. Rather, they shape and reflect the societies that build them, subtly embedding the values and biases of their creators. When governments define which family configurations are “legitimate,” when universities reward particular metrics of excellence, or when tech platforms decide which tweets or posts to amplify, they are all setting standards that become normalized through data. The onus is on us—as researchers, educators, policy makers, and citizens—to question these norms, advocate for designs that respect human complexity, and push for oversight systems that protect against abuses of information. If we fail to do so, we risk empowering data-driven practices that undermine the very ideals of equity, autonomy, and truth they claim to serve.