/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  tf_sa = var.terraform_service_account
}

/******************************************
  Provider credential configuration
 *****************************************/
provider "google" {
  alias = "tokengen"
}

data "google_client_config" "default" {
  provider = google.tokengen

}
data "google_service_account_access_token" "sa" {
  provider               = "google.tokengen"
  target_service_account = local.tf_sa
  lifetime               = "600s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

/******************************************
  GA Provider configuration
 *****************************************/
provider "google" {
  access_token = data.google_service_account_access_token.sa.access_token
  project = "iggycorp-iac"
}
/******************************************
  Beta Provider configuration
 *****************************************/
provider "google-beta" {
  access_token = data.google_service_account_access_token.sa.access_token
  project = "iggycorp-iac"
}