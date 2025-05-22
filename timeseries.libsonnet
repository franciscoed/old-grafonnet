{
  /**
   * Creates a [time series panel](https://grafana.com/docs/grafana/latest/panels/visualizations/time-series/).
   * This version replaces the deprecated Angular graph panel.
   *
   * @name graphPanel.new
   *
   * @param title The title of the time series panel.
   * @param description (optional) The description of the panel
   * @param span (optional) Width of the panel
   * @param datasource (optional) Datasource
   * @param fill (default `1`) , integer from 0 to 10
   * @param linewidth (default `1`) Line Width, integer from 0 to 10
   * @param decimals (optional) Override automatic decimal precision for legend and tooltip. If null, not added to the json output.
   * @param format (default `short`) Unit of the Y axis
   * @param min (optional) Min of the Y axis
   * @param max (optional) Max of the Y axis
   * @param maxDataPoints (optional) If the data source supports it, sets the maximum number of data points for each series returned.
   * @param labelY (optional) Label of the Y axis
   * @param lines (default `true`) Display lines
   * @param points (default `false`) Display points
   * @param pointradius (default `5`) Radius of the points, allowed values are 0.5 or [1 ... 10] with step 1
   * @param stack (default `false`) Whether to stack values
   * @param repeat (optional) Name of variable that should be used to repeat this panel.
   * @param repeatDirection (default `'h'`) 'h' for horizontal or 'v' for vertical.
   * @param legend_show (default `true`) Show legend
   * @param legend_alignAsTable (default `false`) Show legend as table
   * @param legend_rightSide (default `false`) Show legend to the right
   * @param transparent (default `false`) Whether to display the panel without a background.
   * @param value_type (default `'individual'`) Type of tooltip value
   * @param shared_tooltip (default `true`) Allow to group or split tooltips on mouseover within a chart
   * @param interval (default: null) A lower limit for the interval.
   *
   * @method addTarget(target) Adds a target object.
   * @method addTargets(targets) Adds an array of targets.
   * @method addOverride(matcher, properties) Adds a field override.
   * @method addOverrides(overrides) Adds an array of field overrides.
   * @method addLink(link) Adds a [panel link](https://grafana.com/docs/grafana/latest/linking/panel-links/)
   * @method addLinks(links) Adds an array of links.
   */
  new(
    title,
    span=null,
    fill=1,
    linewidth=1,
    decimals=null,
    description=null,
    format='short',
    min=null,
    max=null,
    labelY=null,
    lines=true,
    datasource=null,
    points=false,
    pointradius=5,
    stack=false,
    repeat=null,
    repeatDirection='h',
    legend_show=true,
    legend_alignAsTable=false,
    legend_rightSide=false,
    transparent=false,
    value_type='individual',
    shared_tooltip=true,
    maxDataPoints=null,
    time_from=null,
    time_shift=null,
    interval=null
  ):: {
    title: title,
    [if span != null then 'span']: span,
    [if decimals != null then 'decimals']: decimals,
    type: 'timeseries',
    datasource: datasource,
    targets: [],
    [if description != null then 'description']: description,
    [if maxDataPoints != null then 'maxDataPoints']: maxDataPoints,
    [if time_from != null then 'timeFrom']: time_from,
    [if time_shift != null then 'timeShift']: time_shift,
    [if interval != null then 'interval']: interval,
    [if transparent == true then 'transparent']: transparent,
    repeat: repeat,
    [if repeatDirection != null then 'repeatDirection']: repeatDirection,
    fieldConfig: {
      defaults: {
        unit: format,
        min: min,
        max: max,
        decimals: decimals,
        custom: {
          drawStyle: if lines then 'lines' else 'points',
          lineWidth: linewidth,
          fillOpacity: fill * 10,
          showPoints: points,
          pointSize: pointradius,
          stacking: {
            mode: if stack then 'normal' else 'none',
          },
        },
      },
      overrides: [],
    },
    options: {
      legend: {
        showLegend: legend_show,
        displayMode: if legend_alignAsTable then 'table' else 'list',
        placement: if legend_rightSide then 'right' else 'bottom',
      },
      tooltip: {
        mode: if shared_tooltip then 'multi' else 'single',
      },
    },
    links: [],
    addTarget(target):: self {
      local refId = std.char(std.codepoint('A') + std.length(self.targets)),
      targets+: [target { refId: refId }],
    },
    addTargets(targets):: std.foldl(function(p, t) p.addTarget(t), targets, self),
    addOverride(matcher, properties):: self {
      fieldConfig+: {
        overrides+: [
          {
            matcher: matcher,
            properties: properties,
          },
        ],
      },
    },
    addOverrides(overrides):: std.foldl(function(p, o) p.addOverride(o.matcher, o.properties), overrides, self),
    addLink(link):: self {
      links+: [link],
    },
    addLinks(links):: std.foldl(function(p, t) p.addLink(t), links, self),
  },
}
