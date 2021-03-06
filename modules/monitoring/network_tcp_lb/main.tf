resource "google_monitoring_dashboard" "network_tcp_lb_dashboard" {
  project        = var.project
  count          = var.network_tcp_lb_dashboard_enable ? 1 : 0
  dashboard_json = <<EOF

{
  "displayName": "${var.network_tcp_lb_dashboard_name}",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "RTT latencies [95/50/5 PERCENTILE]",
        "xyChart": {
          "chartOptions": {
            "mode": "COLOR"
          },
          "dataSets": [
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "crossSeriesReducer": "REDUCE_PERCENTILE_95",
                    "groupByFields": [
                      "resource.label.\"load_balancer_name\""
                    ],
                    "perSeriesAligner": "ALIGN_DELTA"
                  },
                  "filter": "metric.type=\"loadbalancing.googleapis.com/l3/external/rtt_latencies\" resource.type=\"tcp_lb_rule\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "ms"
              }
            },
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "crossSeriesReducer": "REDUCE_PERCENTILE_05",
                    "groupByFields": [
                      "resource.label.\"load_balancer_name\""
                    ],
                    "perSeriesAligner": "ALIGN_DELTA"
                  },
                  "filter": "metric.type=\"loadbalancing.googleapis.com/l3/external/rtt_latencies\" resource.type=\"tcp_lb_rule\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "ms"
              }
            },
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "crossSeriesReducer": "REDUCE_PERCENTILE_50",
                    "groupByFields": [
                      "resource.label.\"load_balancer_name\""
                    ],
                    "perSeriesAligner": "ALIGN_DELTA"
                  },
                  "filter": "metric.type=\"loadbalancing.googleapis.com/l3/external/rtt_latencies\" resource.type=\"tcp_lb_rule\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "ms"
              }
            }
          ],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Ingress TCP packets",
        "xyChart": {
          "chartOptions": {
            "mode": "COLOR"
          },
          "dataSets": [
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": [
                      "resource.label.\"load_balancer_name\""
                    ],
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"loadbalancing.googleapis.com/l3/external/ingress_packets_count\" resource.type=\"tcp_lb_rule\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "1"
              }
            }
          ],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Ingress TCP bytes",
        "xyChart": {
          "chartOptions": {
            "mode": "COLOR"
          },
          "dataSets": [
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": [
                      "resource.label.\"load_balancer_name\""
                    ],
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"loadbalancing.googleapis.com/l3/external/ingress_bytes_count\" resource.type=\"tcp_lb_rule\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "By"
              }
            }
          ],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Egress TCP packets",
        "xyChart": {
          "chartOptions": {
            "mode": "COLOR"
          },
          "dataSets": [
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": [
                      "resource.label.\"load_balancer_name\""
                    ],
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"loadbalancing.googleapis.com/l3/external/egress_packets_count\" resource.type=\"tcp_lb_rule\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "1"
              }
            }
          ],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Egress TCP bytes",
        "xyChart": {
          "chartOptions": {
            "mode": "COLOR"
          },
          "dataSets": [
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "crossSeriesReducer": "REDUCE_SUM",
                    "groupByFields": [
                      "resource.label.\"load_balancer_name\""
                    ],
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"loadbalancing.googleapis.com/l3/external/egress_bytes_count\" resource.type=\"tcp_lb_rule\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "By"
              }
            }
          ],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      }
    ]
  }
}



EOF
}