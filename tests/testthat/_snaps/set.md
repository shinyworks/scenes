# set_scene constructs a scene

    Code
      set_scene(ui = shiny::HTML("This is not a UI."))
    Output
      $ui
      This is not a UI.
      
      $actions
      NULL
      
      attr(,"class")
      [1] "shiny_scene" "list"       

---

    Code
      set_scene(ui = shiny::HTML("This is not a UI."), req_has_query("code"))
    Output
      $ui
      This is not a UI.
      
      $actions
      $actions[[1]]
      $check_fn
      function (request) 
      {
          return(.req_has_query_impl(request = request, key = "code", 
              values = NULL))
      }
      <environment: namespace:scenes>
      
      $methods
      [1] "GET"
      
      attr(,"class")
      [1] "scene_action" "list"        
      
      
      attr(,"class")
      [1] "shiny_scene" "list"       

