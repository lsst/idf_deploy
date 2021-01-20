resource "google_monitoring_dashboard" "gcs_dashboard" {
  project        = var.project
  count          = var.gcs_dashboard_enable ? 1 : 0
  dashboard_json = <<EOF
{
  "displayName": "${var.gcs_dashboard_name}",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "Total object count",
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
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"storage.googleapis.com/storage/object_count\" resource.type=\"gcs_bucket\"",
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
        "title": "Total bytes",
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
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"storage.googleapis.com/storage/total_bytes\" resource.type=\"gcs_bucket\"",
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
        "title": "Bucket object count",
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
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"storage.googleapis.com/storage/object_count\" resource.type=\"gcs_bucket\"",
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
        "title": "Bucket total bytes",
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
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"storage.googleapis.com/storage/total_bytes\" resource.type=\"gcs_bucket\"",
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
        "title": "Bucket - Received bytes, Sent bytes",
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
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"storage.googleapis.com/network/received_bytes_count\" resource.type=\"gcs_bucket\"",
                  "secondaryAggregation": {}
                },
                "unitOverride": "By"
              }
            },
            {
              "minAlignmentPeriod": "60s",
              "plotType": "LINE",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "aggregation": {
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"storage.googleapis.com/network/sent_bytes_count\" resource.type=\"gcs_bucket\"",
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
        "title": "Bucket - Request count",
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
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"storage.googleapis.com/api/request_count\" resource.type=\"gcs_bucket\"",
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
      }
    ]
  }
}

EOF
}