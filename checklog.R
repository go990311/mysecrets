library(dplyr)

# establish connection
con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  host     = "HOST",
  user     = "USER",
  password = "PASSWORD",
  port     = PORT,
  dbname   = "DBNAME"
)

# create database table object
dal_ra_checklist <- tbl(con, "dal_ra_checklist")

# use `d(b)plyr` verbs to operate on table
data <- dal_ra_checklist |>
  select(
    id_redcap,
    redcap_event_name,
    ra_scan_check_list_t1,
    ra_scan_check_list_t2,
    ra_scan_cl_mid_scan,
    ra_scan_cl_sst_scan,
    ra_scan_cl_nback_scan
  ) |>
  filter(
    if_any(
      -c(
        id_redcap,
        redcap_event_name
      ),
      ~ !is.na(.x)
    )
  ) |>
  # everything before this command operates only in the database (try it out)
  # using `collect()` actually downloads data from the database and stores in
  # `data` object in the R session
  collect()


summary(data)
