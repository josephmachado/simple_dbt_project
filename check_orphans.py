import json
import logging

manifest_file_path = "./sde_dbt_tutorial/target/manifest.json"

# Read in the json file
with open(manifest_file_path, "r") as file:
    manifest_data = json.load(file)

dbt_tests = [k for k in manifest_data["nodes"].keys() if k.startswith("test")]
dbt_models = [k for k in manifest_data["nodes"].keys() if k.startswith("model")]

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
            f"""
            ####################################################### \n
            The test {dbt_test} is an orphaned test (no model to run this test on) please remove it! \n
            ####################################################### \n"""
        )

for dbt_model in dbt_models:
    dbt_model_node = manifest_data.get("nodes", {}).get(dbt_model, {})
    if (
        len(dbt_model_node.get("refs", [])) == 0
        and len(dbt_model_node.get("sources", [])) == 0
        and dbt_model_node.get("fqn", ["non-existent"])[0] != "elementary"
    ):
        logging.warning(
            f"""
            ####################################################### \n
            The model {'.'.join(dbt_model_node.get('fqn', []))} does not have any sources or ref function, please check it! \n
            ####################################################### \n"""
        )
