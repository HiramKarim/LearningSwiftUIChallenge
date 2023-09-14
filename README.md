# LearningSwiftUIChallenge
This projects is an example of how to implement clean architecture using SwiftUI, Async/Await, Protocols, Solid principles and also using frameworks like KingFisher to make asyncronous fetch of images.
I implemented REALM persistance data to save information locally. Another important implementation is the configuration for the URLSession is has been setting up the timeoutIntervalForResouce and activate the flag "waitsForConnectivity" this will help us to try to reconnect to network services.
Also, the re-try capability is implemented, is up to 3 retrys, after this, the network layer will send back a connectivity error through the usecase - viewmodel, last one should fetch data from realm (if exists).

This is a simple master-detail view that shows a list of meals and a spared view with more details. also, you can search meals using search bar.

web page of the API service:
https://www.themealdb.com/api.php

Architecture implemented:



![Screenshot 2023-09-13 at 11 35 11 p m](https://github.com/HiramKarim/LearningSwiftUIChallenge/assets/16406266/adba597e-2992-4f04-b40b-fdacccc35e5f)



