resource "google_monitoring_dashboard" "gke_dashboard" {
  project = var.project
  count=var.gke_dashboard_enable ? 1: 0
  dashboard_json = <<EOF
{
  "displayName": "${var.gke_dashboard_name}",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "CPU request utilization - GKE",
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
                    "crossSeriesReducer": "REDUCE_PERCENTILE_50",
                    "groupByFields": [
                      "resource.label.\"namespace_name\"",
                      "resource.label.\"cluster_name\""
                    ],
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"kubernetes.io/container/cpu/request_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=starts_with(\""${var.gke_dashboard_filter}\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  },
                  "secondaryAggregation": {}
                }
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
        "title": "Memory request utilization - GKE",
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
                    "crossSeriesReducer": "REDUCE_PERCENTILE_50",
                    "groupByFields": [
                      "resource.label.\"namespace_name\"",
                      "resource.label.\"cluster_name\""
                    ],
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"kubernetes.io/container/memory/request_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=starts_with(\""${var.gke_dashboard_filter}"\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  },
                  "secondaryAggregation": {}
                }
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
        "title": "Memory limit utilization - GKE",
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
                    "crossSeriesReducer": "REDUCE_PERCENTILE_50",
                    "groupByFields": [
                      "resource.label.\"namespace_name\"",
                      "resource.label.\"cluster_name\""
                    ],
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=starts_with(\""${var.gke_dashboard_filter}"\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  },
                  "secondaryAggregation": {}
                }
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