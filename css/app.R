library(shiny)

shinyApp(
ui <- fluidPage(
  sliderInput("obs", "Number of observations", 0, 1000, 500),
  actionLink("infoLink", "Information Link"),
  plotOutput("distPlot"),
),
server <- function(input, output) {
  output$distPlot <- renderPlot({
    # Take a dependency on input$goButton. This will run once initially,
    # because the value changes from NULL to 0.
    input$infoLink
    
    # Use isolate() to avoid dependency on input$obs
    dist <- isolate(rnorm(input$obs))
    hist(dist)
  })
}
)

shinyApp(
  ui = fixedPage(
    h2('输入控件演示'),
    hr(),
    sidebarLayout(
      sidebarPanel(
        textInput('tx', '文字输入', value='abc'),
        checkboxGroupInput(inputId = 'cg', label = '选项组', choices=LETTERS[1:4], selected=c('A', 'D'), inline=TRUE),
        sliderInput('sl', '滑动选数', min=1, max=10, value=6),
        HTML('<label for="tt">文本框输入</label>',
             '<textarea id="tt" class="form-control" style="resize:none"></textarea>'
        ),
        HTML('<label for="clx">颜色选取</label>',
             '<input id="clx" type="color" class="form-control" value="#FF0000">',
             '<input id="cl" type="text" class="form-control" value="#FF0000" style="display:none">',
             '<script>',
             '$(function(){$("#clx").change(function(){$("#cl").val($(this).val()).trigger("change");});})',
             '</script>'
        )
      ),
      mainPanel(
        HTML('<textarea id="ta" class="form-control shiny-text-output"',
             'style="resize:none; height:200px;" readonly></textarea>'
        )
      )
    )
  ),
  server = function(input, output, session) {
    output$ta <- renderText({
      paste(c(input$tx, input$tt, paste(input$cg, collapse='; '),
              input$sl, input$cl), collapse='\n')
    })
    observe({
      updateTextInput(session, inputId='tt', value=paste('文本输入：', input$tx))
    })
  }
)