/*
/// Module: todolistartero
module todolistartero::todolistartero;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions
module todolistartero::todo {

    use std::debug::print;
    use std::string::{utf8, append_utf8};

    public struct TodoListArtero has key, store {
        id: UID,
        tasks: vector<Task>,
    }

    public struct Task has key, store {
        id: UID,
        description: vector<u8>,
        completed: bool,
    }
    
    public fun add_task(description: vector<u8>, ctx: &mut TxContext, app: &mut TodoListArtero) {
        let mut message = utf8(b"Nova Task: ");
        append_utf8(&mut message, description);
        print(&message);
        let task = Task {
            id: object::new(ctx),
            description: description,
            completed: false,
        };

        app.tasks.push_back(task);
    }

    public fun new(ctx: &mut TxContext) {
        print(&utf8(b"Criando novo objeto TodoListArtero"));
        let app = TodoListArtero {
            id: object::new(ctx),
            tasks: vector[],
        };
        
        transfer::transfer(app, tx_context::sender(ctx));        
    }

    public fun get_task_count(app: &TodoListArtero): u64 {
        vector::length(&app.tasks)
    }

    public fun get_task(app: &TodoListArtero, index: u64): &Task {
        vector::borrow(&app.tasks, index)
    }

    public fun is_task_completed(app: &TodoListArtero, index: u64): bool {
        let task = vector::borrow(&app.tasks, index);
        task.completed
    }


}

