import json
import logging

manifest_file_path = "./sde_dbt_tutorial/target/manifest.json"

# Read in the json file
with open(manifest_file_path, "r") as file:
    manifest_data = json.load(file)

dbt_tests = [k for k in manifest_data["nodes"].keys() if k.startswith("test")]

for dbt_test in dbt_tests:
    if (
        len(
            manifest_data.get("nodes", {})
            .get(dbt_test, {})
            .get("depends_on", {})
            .get("nodes", [])
        )
        == 0
    ):
        logging.warning(
            f"################# The test {dbt_test} is an orphaned test (no model to run this test on) please remove it! #######################"
        )
