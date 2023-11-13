# The default ui works as expected.

    Code
      default_ui()
    Condition
      Warning:
      No ui specified for this request. Loading default ui.
    Output
      $status
      [1] 422
      
      $content_type
      [1] "text/plain"
      
      $content
      [1] "422: Unprocessable Entity. The conditions necessary to choose a UI were not met."
      
      $headers
      $headers$`X-UA-Compatible`
      [1] "IE=edge,chrome=1"
      
      
      attr(,"class")
      [1] "httpResponse"

