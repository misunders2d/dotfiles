---
name: streamlit-echarts
description: Guide and patterns for creating charts in Streamlit using streamlit_echarts and pyecharts. Use this when you need to render interactive ECharts in a Streamlit application.
---

# Streamlit ECharts

This skill provides patterns for using the `streamlit-echarts` library to render Apache ECharts within Streamlit applications.

## Core Imports

```python
import streamlit as st
from streamlit_echarts import st_echarts
# If using pyecharts:
# from streamlit_echarts import st_pyecharts
```

## Basic Usage (st_echarts)

The primary way to use `streamlit-echarts` is to pass an ECharts JSON configuration as a Python dictionary.

```python
options = {
    "title": {"text": "Basic Bar Chart"},
    "tooltip": {},
    "legend": {"data": ["Sales"]},
    "xAxis": {"data": ["Shirts", "Cardigans", "Chiffons", "Pants", "Heels", "Socks"]},
    "yAxis": {},
    "series": [{"name": "Sales", "type": "bar", "data": [5, 20, 36, 10, 10, 20]}],
}

# Render the chart
st_echarts(options=options, height="400px")
```

## Advanced Usage

### Capturing Events

You can capture user interactions (like clicks) using the `events` parameter.

```python
events = {
    "click": "function(params) { return params.name; }"
}

clicked_label = st_echarts(options=options, events=events, height="400px")
if clicked_label:
    st.write(f"You clicked on: {clicked_label}")
```

### Theming

Use the `theme` parameter for basic themes like `"dark"` or `"vintage"`.

```python
st_echarts(options=options, theme="dark", height="400px")
```

### Passing Javascript (JsCode)

If you need to pass JavaScript functions (e.g., for custom tooltips or formatters), use `JsCode`.

```python
from streamlit_echarts import JsCode

options = {
    "tooltip": {
        "formatter": JsCode(
            "function(params) { return 'Value: ' + params.value; }"
        ).js_code
    },
    # ...
}
```

## Pyecharts Integration (st_pyecharts)

If you prefer an object-oriented API via `pyecharts`:

```python
from pyecharts import options as opts
from pyecharts.charts import Bar
from streamlit_echarts import st_pyecharts

b = (
    Bar()
    .add_xaxis(["Microsoft", "Amazon", "IBM", "Oracle", "Google", "Alibaba"])
    .add_yaxis("Revenue", [21.2, 20.4, 10.3, 6.08, 4, 2.2])
    .set_global_opts(title_opts=opts.TitleOpts(title="Top Cloud Providers"))
)

st_pyecharts(b, height="400px")
```

## Common Considerations
- The `options` dictionary should match the official Apache ECharts JSON configuration structure.
- Always provide a `height` parameter (e.g., `height="400px"`) to prevent the chart from collapsing.