# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Postman response final:

localhost:3000/api/v1/book-search?location=denver,co&quantity=5

{
    "data": {
        "id": null,
        "type": "books",
        "attributes": {
            "destination": "denver,co",
            "forecast": {
                "summary": "Partly cloudy",
                "temperature": "70.9 F"
            },
            "total_books_found": 769,
            "books": [
                {
                    "isbn": [
                        "0607620056",
                        "9780607620054"
                    ],
                    "title": "Denver west, CO and Bailey, CO: Denver, CO",
                    "publisher": [
                        "USGS Branch of Distribution"
                    ]
                },
                {
                    "isbn": [
                        "0738518700",
                        "9780738518701"
                    ],
                    "title": "Five Points Neighborhood of Denver  (CO)",
                    "publisher": [
                        "Arcadia",
                        "Arcadia  Publishing (SC)"
                    ]
                },
                {
                    "isbn": [
                        "9789812582621",
                        "9812582622"
                    ],
                    "title": "Insight Fleximap Denver, CO (Insight Fleximaps)",
                    "publisher": [
                        "American Map Corporation"
                    ]
                },
                {
                    "isbn": [
                        "1541184254",
                        "9781541184251"
                    ],
                    "title": "Denver, CO, US Dot-Grid Notebook",
                    "publisher": [
                        "Createspace Independent Publishing Platform",
                        "CreateSpace Independent Publishing Platform"
                    ]
                },
                {
                    "isbn": [
                        "0607620048",
                        "9780607620047"
                    ],
                    "title": "Denver East, CO and Castle Rock, CO: Denver, CO",
                    "publisher": [
                        "USGS Branch of Distribution"
                    ]
                }
            ]
        }
    }
}