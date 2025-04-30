########
Concepts
########

****
Task
****
A task is similar to a calendar item. It has a time and a date. 

Tasks can be marked as complete by the user.

It optionally has a location. A task with a location can only be marked complete if the user has visited the location at the time of the task.

The app will send push notifications for each task, according to an interval associated with that task. 

Tasks can optionally repeat. A task which repeats will have an associated repeat interval. 
A task which does not repeat will have no repeat interval. 

Some tasks (as configured by the user) can be delayed or otherwise moved.

*****
Habit
*****
A habit is a task which repeats. 

TODO can habits be moved? How does that work?

********
Schedule
********
A schedule is defined over a day. A day's schedule may have zero or more tasks (normally more). 

*******
Backlog
*******
The backlog is a collection of tasks that have yet to be scheduled.

******
Streak
******
The streak is a record of the number of days the user has met their point goal. 
The point of the streak is to encourage the user to consistently mark tasks as complete (i.e. consistently do tasks)
The streak is said to be broken when the user fails to meet their point goal, and is said to be maintained when the user successfully meets their point goal. 

Difficulty
==========
Every user account has an associated difficulty setting.
The difficulty setting determines what proportion of the day's available points need to be attained in order for the streak to be maintained.
The default proportions for each difficulty are stored in ``assets/settings.json``. 

********
Category
********
Tasks are categorised according into 6 predefined categories.
These are 
The categories are ranked by the user
Points are awarded based on this ranking (Expand these)

******
Points
******
The user is awarded points for completing a task. 

TODO figure out how points are / should be calculated.