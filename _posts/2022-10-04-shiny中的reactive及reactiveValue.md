# Shiny中的reactive及reactiveValue

## 数据响应

[原文链接](https://blog.csdn.net/u014801157/article/details/48196913)

---

我们使用的server端函数都是自动响应数据变化的函数。但那些都是“动作”类型的函数，如renderPlot进行绘图，renderText输出文本，observe监测ui端变化并响应。如果server端需要一个仅用于存储ui端数据的变量，该怎么做呢？很自然的想法是直接使用赋值语句：

让我们首先来看一段代码：

```shell
shinyApp(
  ui = fixedPage(
    textInput("itx", "请随便输入"),
    textOutput("otx", container=pre)
  ),
  server = function(input, output, session) {
    itx <- input$itx
    output$otx <- renderPrint({
      itx
    })
  }
)
```

> shiny（至少现在的版本）不允许在规定的函数环境外面使用input数据，更不要说用这些变量存储数据供后面的代码使用。即使是这么简单的赋值，也需要使用规定的函数：reactive。把上面server中的代码改成下面代码就可以运行了：

```shell
shinyApp(
  ui = fixedPage(
    textInput("itx", "请随便输入"),
    textOutput("otx", container=pre)
  ),
  server = function(input, output, session) {
    itx <- reactive({input$itx})
    output$otx <- renderPrint({
      itx()
    })
  }
)
```
