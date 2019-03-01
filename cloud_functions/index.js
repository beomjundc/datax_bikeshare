/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */

const rp = require('request-promise');
const BigQuery = require('@google-cloud/bigquery');

exports.fetchStationStatus = (req, res) => {
  const projectId = "ieor290-datax-bikeshare"; //Enter your project ID here
  const datasetId = "gobike_tripdata"; //Enter your BigQuery dataset name here
  const tableId = "station_status"; //Enter your BigQuery table name here -- make sure it is setup correctly
  
  var options = {
    uri: 'https://gbfs.fordgobike.com/gbfs/en/station_status.json',
    json: true // Automatically parses the JSON string in the response
  };
 
  rp(options)
    .then(function (response) {
        console.log(response);

        var last_updated = response.last_updated;
        var stations = response.data.stations;
        var rows = [];

        stations.forEach(function(s) {
          /*
          "station_id": "5",
          "num_bikes_available": 12,
          "num_ebikes_available": 5,
          "num_bikes_disabled": 3,
          "num_docks_available": 20,
          "num_docks_disabled": 0,
          "is_installed": 1,
          "is_renting": 1,
          "is_returning": 1,
          "last_reported": 1551462342,
          "eightd_has_available_keys": false
          */
          var row = {"last_updated":last_updated, "station_id":s.station_id, "num_bikes_available":s.num_bikes_available, "num_ebikes_available":s.num_ebikes_available, "num_bikes_disabled":s.num_bikes_disabled, "num_docks_available":s.num_docks_available, "num_docks_disabled":s.num_docks_disabled, "is_installed":s.is_installed, "is_renting":s.is_renting, "is_returning":s.is_returning, "last_reported":s.last_reported, "eightd_has_available_keys":s.eightd_has_available_keys};
          rows.push(row);
        });


        console.log(`Uploading data: ${rows}`);
        
        // Instantiates a client
        const bigquery = BigQuery({
          projectId: projectId
        });

        // Inserts data into memeid table
        bigquery
          .dataset(datasetId)
          .table(tableId)
          .insert(rows)
          .then((foundErrors) => {
            rows.forEach((row) => console.log('Inserted: ', row));

            if (foundErrors && foundErrors.insertErrors != undefined) {
              foundErrors.forEach((err) => {
                  console.log('Error: ', err);
              })
            }
          })
          .catch((err) => {
            console.error('ERROR:', err);
          });
        // [END bigquery_insert_stream]


        //callback();
        
        res.status(200).send({"rows":rows});
    })
    .catch(function (err) {
        res.status(404).send("error");
    });
};