## CampusFind: Lost & Found Management System

An interactive web application designed to streamline the reporting and recovery of lost items through **spatial mapping** and **real-time data visualization**. Built using a Flask-Python backend and a Leaflet.js frontend, this project highlights efficient database management and interactive UI design.

---

### Overview

This project provides a centralized platform for users to report lost or found items and visualize their locations on a custom campus map. It serves as a practical tool for managing campus logistics, supporting both active item tracking and historical data analysis through a dedicated dashboard.

---

### Grid Environment (Campus Map)

* **Structure**: 2D coordinate-based flat image map.
* **Elements**:
    * **Lost Pins**: Red markers indicating missing items.
    * **Found Pins**: Green markers indicating recovered items.
    * **Claimed Pins**: Blue markers indicating resolved cases.
* **Customization**: Users can precisely "Pin on Map" to drop markers at exact coordinates.

---

### Tech Stack

#### **Frontend**
* **HTML5 & CSS3**: Custom dark-themed UI using *Plus Jakarta Sans* and *DM Sans* for modern typography.
* **JavaScript (ES6+)**: Handles dynamic rendering, view switching, and asynchronous API calls to the backend.
* **Leaflet.js**: Powering the spatial engine using a `CRS.Simple` coordinate system for non-geographic mapping.

#### **Backend**
* **Python**: The primary language for server-side logic and database integration.
* **Flask**: A lightweight framework used to build RESTful API endpoints and serve static frontend assets.
* **Flask-CORS**: Middleware enabling secure Cross-Origin Resource Sharing between the frontend and the server.

#### **Database**
* **MySQL**: Relational database for persistent storage of users, lost/found entries, and claims.
* **mysql-connector-python**: The driver used for executing SQL queries and managing data transactions.

---

### Features

* **Interactive Spatial Mapping**: Map items onto a custom campus layout using pixel-based coordinates.
* **Real-Time Dashboard**: Visualize status breakdowns, item categories, and location hotspots.
* **Automated User Management**: Automatically handles reporter records while supporting anonymous submissions.
* **Search & Filter**: Dynamically filter items by type (lost/found/claimed), category, or location.
* **Relational Integrity**: Uses a unified `claims` table to link and resolve entries between lost and found tables.

---

### Database Schema

| Table | Description |
| :--- | :--- |
| **`users`** | Profiles for reporters and claimants, including roles and contact info. |
| **`lost_items`** | Records items reported missing with category and spatial coordinates. |
| **`found_items`** | Records recovered items and their current status. |
| **`claims`** | Links items to claimants with status tracking and verification notes. |

---

### Run Locally

1.  **Install dependencies**:
    ```bash
    pip install -r requirements.txt
    ```
2.  **Configure Database**: Update `config.py` with your local MySQL credentials.
3.  **Run Application**:
    ```bash
    python app.py
    ```
    Access the application at `http://localhost:5000`.
