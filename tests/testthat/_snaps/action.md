# req_has_query returns the expected object

    Code
      result_key_only
    Output
      $check_fn
      function (request) 
      {
          return(.req_has_query_impl(request = request, key = "testkey", 
              values = NULL))
      }
      <environment: namespace:scenes>
      
      $methods
      [1] "GET"
      
      attr(,"class")
      [1] "scene_action" "list"        

---

    Code
      result_value
    Output
      $check_fn
      function (request) 
      {
          return(.req_has_query_impl(request = request, key = "testkey", 
              values = "a"))
      }
      <environment: namespace:scenes>
      
      $methods
      [1] "GET"
      
      attr(,"class")
      [1] "scene_action" "list"        

---

    Code
      result_values
    Output
      $check_fn
      function (request) 
      {
          return(.req_has_query_impl(request = request, key = "testkey", 
              values = c("a", "b", "c")))
      }
      <environment: namespace:scenes>
      
      $methods
      [1] "GET"
      
      attr(,"class")
      [1] "scene_action" "list"        

