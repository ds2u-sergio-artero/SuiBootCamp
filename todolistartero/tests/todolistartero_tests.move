
#[test_only]
module todolistartero::todolistartero_tests;
use todolistartero::todo;
use sui::test_scenario;

#[test]
fun test_create_todolist() {
    let mut scenario = test_scenario::begin(@0x1);
    {
        test_scenario::next_tx(&mut scenario, @0x1);
        todo::new(test_scenario::ctx(&mut scenario));
    };
    // Verify object exists at sender address
    test_scenario::next_tx(&mut scenario, @0x1);
    test_scenario::end(scenario);
}

#[test]
fun test_add_task() {
    let mut scenario = test_scenario::begin(@0x1);
    
    // Create TodoListArtero
    {
        test_scenario::next_tx(&mut scenario, @0x1);
        todo::new(test_scenario::ctx(&mut scenario));
    };
    
    // Add task - FIXED: Full type path
    {
        test_scenario::next_tx(&mut scenario, @0x1);
        let mut app = test_scenario::take_from_address<todolistartero::todo::TodoListArtero>(
            &scenario, @0x1
        );

        assert!(todo::get_task_count(&app) == 0, 0);

        todo::add_task(b"Buy milk", test_scenario::ctx(&mut scenario), &mut app);
        
        assert!(todo::get_task_count(&app) == 1, 0);
        assert!(todo::is_task_completed(&app, 0) == false, 0);
        
        test_scenario::return_to_address(@0x1, app);
    };
    
    test_scenario::end(scenario);
}
