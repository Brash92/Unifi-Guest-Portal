## Background

Recently I had to develop a Public Wifi solution leveraging Ubiquiti equipment.
I wasn't interested in building my own guest portal and therefore was primarily looking at using the one built into the controller.

My requirements were:
 - Users needed to be able to connect for the entire business hours of the premise - the longest being 5am - 9pm
 - Users should be bandwidth shaped
 - Users should have a download cap of 2GB per day
 
In order to meet the data cap requirements, the guest portal needed to be configured as a voucher based system using the "free trial" option.
However, the guest portal doesn't provide an option to end all user sessions at the end of the day.
Therefore, an edge case  is that if a user connects in the afternoon of one day, they will not be able to logon in the morning of the next.


## Overview

The Ubiquiti wireless solution provides a decent enough guest portal for most use cases but it doesn't have a good way to clear user sessions at the end of the day.
In order to do this, I created a Powershell script to iterate through each site, extend and then disconnect all sessions at the end of each day.
This effectively disconnects all sessions, thereby enabling all users to be able to logon the next morning if required.
Extending prior to disconnecting is required in case a user has hit the download cap, in which case their session can't be disconnected as normal.




