resource "google_monitoring_dashboard" "gke_disk_dashboard" {
  project        = var.project
  count          = var.gke_disk_dashboard_enable ? 1 : 0
  dashboard_json = <<EOF

{
  "displayName": "${var.gke_disk_dashboard_name}",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "Disk Read Operations",
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
                    "groupByFields": [
                      "metric.label.\"device_name\""
                    ],
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"compute.googleapis.com/instance/disk/read_ops_count\" resource.type=\"gce_instance\" resource.label.\"project_id\"=starts_with(\"${var.gke_dashboard_filter}\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  },
                  "secondaryAggregation": {
                    "perSeriesAligner": "ALIGN_MEAN"
                  }
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
        "title": "Disk Write Operations",
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
                    "groupByFields": [
                      "metric.label.\"device_name\""
                    ],
                    "perSeriesAligner": "ALIGN_RATE"
                  },
                  "filter": "metric.type=\"compute.googleapis.com/instance/disk/write_ops_count\" resource.type=\"gce_instance\" resource.label.\"project_id\"=starts_with(\"${var.gke_dashboard_filter}\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  },
                  "secondaryAggregation": {
                    "perSeriesAligner": "ALIGN_MEAN"
                  }
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
        "title": "Peak disk read ops - GKE Node",
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
                    "crossSeriesReducer": "REDUCE_MAX",
                    "groupByFields": [
                      "metric.label.\"device_name\"",
                      "metric.label.\"storage_type\""
                    ],
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"compute.googleapis.com/instance/disk/max_read_ops_count\" resource.type=\"gce_instance\" resource.label.\"project_id\"=starts_with(\"${var.gke_dashboard_filter}\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  }
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
        "title": "Peak disk write ops - GKE Node",
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
                      "metric.label.\"device_name\""
                    ],
                    "perSeriesAligner": "ALIGN_MEAN"
                  },
                  "filter": "metric.type=\"compute.googleapis.com/instance/disk/max_write_ops_count\" resource.type=\"gce_instance\" resource.label.\"project_id\"=starts_with(\"${var.gke_dashboard_filter}\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  }
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
        "title": "Bytes Read - Filestore",
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
                  "filter": "metric.type=\"file.googleapis.com/nfs/server/read_bytes_count\" resource.type=\"filestore_instance\" resource.label.\"project_id\"=starts_with(\"${var.gke_dashboard_filter}\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  }
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
        "title": "Bytes Written - Filestore",
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
                  "filter": "metric.type=\"file.googleapis.com/nfs/server/write_bytes_count\" resource.type=\"filestore_instance\" resource.label.\"project_id\"=starts_with(\"${var.gke_dashboard_filter}\")",
                  "pickTimeSeriesFilter": {
                    "direction": "TOP",
                    "numTimeSeries": 5,
                    "rankingMethod": "METHOD_MEAN"
                  }
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