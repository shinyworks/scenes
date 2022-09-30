# Scene changing works in the most basic case.

    Code
      attr(test_result, "srcref")
    Output
      function(request) {
          # Loop through the scenes, in order. If one passes, process it and return
          # it. The structure here is partially inspired by purrr::detect, at least
          # in that it made it feel ok to do this with a for loop that we escape
          # from.
          for (i in seq_along(scenes)) {
            scene <- scenes[[i]]
      
            if (
              # A scene with no actions always triggers if we get to it.
              !length(scene$actions) ||
              # This seems backwards, but isn't! scene$actions is a list of actions,
              # each of which has a function, so we're taking each function, and using
              # it to test the request.
              purrr::every(
                scene$actions,
                ~.x$check_fn(request)
              )
            ) {
              return(
                .parse_ui(scene$ui, request)
              )
            }
          }
      
          # TODO: Include a default argument after ... to encourage/remind people to
          # include SOMETHING as a fall-through. I'll probably include a ui-function
          # in the package that's the default here, and have it return a 501 (Not
          # Implemented).
        }

# Scene change functions work as expected

    Code
      attr(test_result, "srcref")
    Output
      function(request) {
          # Loop through the scenes, in order. If one passes, process it and return
          # it. The structure here is partially inspired by purrr::detect, at least
          # in that it made it feel ok to do this with a for loop that we escape
          # from.
          for (i in seq_along(scenes)) {
            scene <- scenes[[i]]
      
            if (
              # A scene with no actions always triggers if we get to it.
              !length(scene$actions) ||
              # This seems backwards, but isn't! scene$actions is a list of actions,
              # each of which has a function, so we're taking each function, and using
              # it to test the request.
              purrr::every(
                scene$actions,
                ~.x$check_fn(request)
              )
            ) {
              return(
                .parse_ui(scene$ui, request)
              )
            }
          }
      
          # TODO: Include a default argument after ... to encourage/remind people to
          # include SOMETHING as a fall-through. I'll probably include a ui-function
          # in the package that's the default here, and have it return a 501 (Not
          # Implemented).
        }

# Scene changes work for ui functions.

    Code
      attr(test_result, "srcref")
    Output
      function(request) {
          # Loop through the scenes, in order. If one passes, process it and return
          # it. The structure here is partially inspired by purrr::detect, at least
          # in that it made it feel ok to do this with a for loop that we escape
          # from.
          for (i in seq_along(scenes)) {
            scene <- scenes[[i]]
      
            if (
              # A scene with no actions always triggers if we get to it.
              !length(scene$actions) ||
              # This seems backwards, but isn't! scene$actions is a list of actions,
              # each of which has a function, so we're taking each function, and using
              # it to test the request.
              purrr::every(
                scene$actions,
                ~.x$check_fn(request)
              )
            ) {
              return(
                .parse_ui(scene$ui, request)
              )
            }
          }
      
          # TODO: Include a default argument after ... to encourage/remind people to
          # include SOMETHING as a fall-through. I'll probably include a ui-function
          # in the package that's the default here, and have it return a 501 (Not
          # Implemented).
        }

---

    Code
      attr(test_result2, "srcref")
    Output
      function(request) {
          # Loop through the scenes, in order. If one passes, process it and return
          # it. The structure here is partially inspired by purrr::detect, at least
          # in that it made it feel ok to do this with a for loop that we escape
          # from.
          for (i in seq_along(scenes)) {
            scene <- scenes[[i]]
      
            if (
              # A scene with no actions always triggers if we get to it.
              !length(scene$actions) ||
              # This seems backwards, but isn't! scene$actions is a list of actions,
              # each of which has a function, so we're taking each function, and using
              # it to test the request.
              purrr::every(
                scene$actions,
                ~.x$check_fn(request)
              )
            ) {
              return(
                .parse_ui(scene$ui, request)
              )
            }
          }
      
          # TODO: Include a default argument after ... to encourage/remind people to
          # include SOMETHING as a fall-through. I'll probably include a ui-function
          # in the package that's the default here, and have it return a 501 (Not
          # Implemented).
        }

