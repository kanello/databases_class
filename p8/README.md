# Greenhouse Management System

## MPCS 533001 - Final Project: Database Driven Web App

### Setting up the database

- run `sqlite3 greenhouse.db`
- run `.read create_db.sql`
- run `.read populate_db.sql`

### Start running

Go to `localhost:8080` to start using my webapp.

The tables used to this project are `plants_active` and `trusses_status`

### Search

#### **Wildcard Search**

The "crop variety" field is a wildcard search.
Options that currently live in the database are:

- piccolo
- brioso
- sunstream

I have also provided a link to check which crop varieties are currently in the database along with some ideas on which ones you can add

#### **Other Details on Search**

- Below the "Search Results" header you will find details about the most recent search you ran so you can search again and tweak some parameter if you'd like.

### View Relation Y and Add Relation Y

Both of these links will direct you to the same page. I combined the functionality for view records related to RelX and add records related to RelX. To make it clear that I've done both of these, I left both links there. Preferably, I'd only use one of the links though don't want to potentially lose points
