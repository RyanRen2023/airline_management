# Group Project: Airline Management System

## Overview
This project is an Airline Management System designed to manage various aspects of an airline, including customers, airplanes, flights, and reservations. Each section of the application is handled by a different team member, ensuring a comprehensive and well-rounded development process.

## Main Page
The main page of the application serves as the entry point and includes four buttons. Each button navigates to a different section of the project:

1. Customer List Page
2. Airplane List Page
3. Flights List Page
4. Reservation Page

## Project Sections

### 1. Customer List Page
**Developer:** Xihai Ren  
**Email:** ren00055@algonquinlive.com

**Features:**
- Add new customers with fields for first name, last name, address, and birthday.
- View, update, and delete customers.
- Use `EncryptedSharedPreferences` to save data from the previous customer for quick entry.

### 2. Airplane List Page
**Developer:** Sigian Liu  
**Email:** liu00638@algonquinlive.com

**Features:**
- Add new airplanes with fields for airplane type, number of passengers, maximum speed, and range.
- View, update, and delete airplanes.
- Use `EncryptedSharedPreferences` to save data for quick entry.

### 3. Flights List Page
**Developer:** Yaozhou Xie  
**Email:** xie00087@algonquinlive.com

**Features:**
- Add new flights with fields for departure city, destination city, departure time, and arrival time.
- View, update, and delete flights.
- Use `EncryptedSharedPreferences` to save data for quick entry.

### 4. Reservation Page
**Developer:** Huacong Xie  
**Email:** xie00088@algonquinlive.com

**Features:**
- Add new reservations with fields for customer, flight, and date.
- View, update, and delete reservations.
- Use `EncryptedSharedPreferences` to save data for quick entry.

## Common Features Across All Sections
- **ListView:** Displays items inserted by the user.
- **TextField and Button:** Allow users to insert items into the ListView.
- **Database Integration:** Store items in a database to repopulate the list when the application restarts.
- **Detail View:** Show details of selected items from the ListView.
- **Notifications:** Use `Snackbar` and `AlertDialog` for notifications.
- **ActionBar:** Include ActionItems with an `AlertDialog` for instructions.
- **Multi-language Support:** Support at least one additional language, or both British and American English.
- **Professional UI:** Ensure GUI elements are properly laid out and aligned.
- **Documentation:** Use JavaDoc comments to document functions and variables. Create JavaDocs in a `JavaDocs` folder.

## Development and Collaboration
- **Version Control:** Use GitHub for code management and merging through pull requests.
- **Integration:** All activities are integrated into a single working application on a single device or emulator.

## How to Use the Interface
Each section of the project comes with an `ActionBar` that includes instructions on how to use the interface. Click on the help icon in the ActionBar to view these instructions.

## Getting Started
1. Clone the repository from GitHub.
2. Open the project in your preferred IDE.
3. Build and run the application on an emulator or device.

## Contributing
Please follow the standard GitHub workflow for contributing to the project:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push to your branch.
4. Create a pull request to merge your changes into the main branch.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Contact
For any questions or further information, please contact the respective developers via their email addresses listed above.