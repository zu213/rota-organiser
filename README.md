# Rota organiser
📅 Organise your rota, with time offs.

Basic Ruby test project that allows input of shifts and job roles required and outputs a rota, takes into account holidays as well.

- `sample_hours.csv` - Contains the different roles adn the amount of staff need accross the the day for said hours.
- `sample_workers.csv` - Contains the workers, there role, there max weekly hours and any hours they have booked off.
- Time booked of is prioritised by who would've booked it off first, with lower numbers in the string representing this.

## Use
1) Input relevant data into the attached .csv files
2) Run `Ruby rote_generator.rb`

Example output:  
`Shifts for Junior are ( 1 ), ( 1 ), ( 1 ), ( 1 ), ( 1 ), ( 1 ), ( 1 ), ( 1 ), ( 3 ), ( 3 ), ( 3 ), ( 3 ), ( 3 ), ( 3 ), ( 3 ), ( 3 ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ )  `<br>
`Shifts for Senior are ( 2 ), ( 2 ), ( 2 ), ( 2 ), ( 2 ), ( 2 ), ( 2 ), ( 2 ), ( 4, 5 ), ( 4, 5 ), ( 4, 5 ), ( 4, 5 ), ( 4, 5 ), ( 4, 5 ), ( 4, 5 ), ( 4, 5 ), ( 6 ), ( 6 ), ( 6 ), ( 6 ), ( 6 ), ( 6 ), ( 6 ), ( 6 )   `<br>
`Shifts for Specialist_Cardio are ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( 5, 6 ), ( 5, 6 ), ( 5, 6 ), ( 5, 6 ), ( 5, 6 ), ( 5, 6 ), ( 5, 6 ), ( 5, 6 ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ ), ( _ )`  <br>

Where the numbers represent employees ID's over the 24 hours of a day.

### Future
TODO: Add detection for if shift requirments for staff are not met.  
TODO: Expand the data to cover multiple days.  