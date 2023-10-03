#Queue Management System

This project simulates a basic queue management system, useful for scenarios such as ticket-selling platforms where there's a need to control the concurrent number of users performing certain actions (e.g., purchasing tickets for a concert).

##Overview

When users access the system, they are assigned a turn. The system continuously checks for users with a `waiting` status and sequentially updates their status to `active` and eventually to `completed`.

While a user's turn is active, the interface changes to notify the user that they can proceed with their actions. The system also displays a count of the number of users ahead of the current user in the queue.

##Features

**Real-time Updates**: The project uses TurboStreams to update the frontend in real-time without requiring a page refresh.

**Background Processing**: The project employs Sidekiq to handle background tasks, continuously polling and updating user statuses.

**Queue Management**: As users wait, they are updated about how many users are ahead of them in the queue.

**Status Indication**: The user interface will visually indicate when it's the user's turn to proceed.

##Technical Implementation
**TurnManagerJob**

This background job continuously monitors for any users in a waiting status. When found, it updates their status to active and eventually to completed. During this process, real-time updates are broadcasted to the frontend using TurboStreams.

**Frontend**

The frontend listens for TurboStream updates and reflects the changes accordingly. It provides visual cues to users about their current status and the number of users ahead of them.

**Turn Model**

A Turn represents a user's position and status in the system. The status can be one of waiting, active, or completed.

## Future improvements
- Right now the project only works with a concurrency of 1

## How to run
`bin/setup`

`bin/rails db:migrate`

`bin/dev`

In another terminal:

`bundle exec sidekiq -c 1`

If you want to create some Turns in the console:

`5.times { Turn.create }`