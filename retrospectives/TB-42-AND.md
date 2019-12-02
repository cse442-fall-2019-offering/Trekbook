# Documenting the Current Work
* Two of the videos of the front end hitting a mock api were in the slack #dev channel.
* The retrofit library has been setup with a singleton and tested in both the Login and the Signup
* Implemented a logout button that will hit the endpoint on the server

# What went Wrong?
* When making a switch from using the Postman mock server to the django server, the data layouts in json were not the same, so integration was not flawless
* For now only the emulator will work for a local instance of the django

# How to Fix this?
* I have made a ticket for us to investigate using swagger api documentation. We tried to make a slack channel to talk it out, but it didn't get used as effectively as it needed to