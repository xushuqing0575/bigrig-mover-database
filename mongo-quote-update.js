// Selected quote-update excerpt from T6-brm-mongo.mongodb.js
// Run against a test customer_quotes collection containing customer _id 1001.
// Select your own test database before running. This replaces the quotes array.

// (ii) Add new quote
db.customer_quotes.updateOne(
    { "_id":{ "$eq":1001}},
    {
      "$set": {
            "customer_stats.number_of_quotes": 1,
            "customer_stats.number_of_jobs": 1,
            "customer_stats.total_paid_jobcost": "$3200.00",
            "customer_stats.total_unpaid_jobcost": "-",
            "quotes": [
                {
                    "quote_no": 2002,
                    "quote_prepared_on": "15-Jul-2026",
                    "preferred_start_date": "20-Jul-2026",
                    "start_location": "Adelaide SA",
                    "end_location": "Melbourne VIC",
                    "quote_cost": "$3200.00",
                    "assigned_to_job": "Y",
                    "job_cost": "$3200.00"  
                }
            ]
        }
    }
);

// Show the customer details
db.customer_quotes.find(
    { "_id": { "$eq" : 1001}}
);
