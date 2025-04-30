====================
Project Architecture
====================

This project is written using google's Flutter framework. More information here: https://flutter.dev/
Flutter is multi-platform, although the tooling and configuration will vary depending on the target platform. 
This project targets iOS. The flutter framework includes the Cupertino library, 
"a collection of widgets that implement Apple's iOS design language". However, this project uses 
Material widgets, the default for flutter, that implement Google's Material 3 design specification. 

The app is divided into 3 layers:
1. Presentation layer
2. Business Logic Layer
3. Database Layer

Presentation Layer
------------------

The code for this layer is contained in the `userInterfaces` subdirectory of the `lib` directory. 

This code deals with displaying the GUI and handling user input. Where the user actions may require 
some kind of data processing, the code in this layer will call methods implemented by the business logic layer.

Business Logic Layer
--------------------

The code for this layer is not contained in a single directory. All of the project code is in the `lib` 
directory, including the code for the presentation and database layers, in their own subdirectories.
Everything outside of those subdirectories is business logic code.

This code deals with processing data. It implements several methods which may be called by the presentation layer.
When data needs to be permanently stored or retrieved, the code in this layer will call methods implemented by the database layer.

Database Layer
--------------
The code for this layer is contained in the `database` subdirectory of the `lib` directory. 

This code deals with the storage, retrieval and updating of data in the database. It implements 
several methods which may be called by the business logic layer.