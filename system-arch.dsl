// =============================================================================
//  Regulatory / Risk-Computation Forecasting Platform
//  Structurizr DSL  --  validated against https://playground.structurizr.com
// -----------------------------------------------------------------------------
//  >>> REBRANDING <<<
//  The platform name is fully segregated into the constants below.
//  Change PLATFORM_NAME (and optionally PLATFORM_DESC) ONLY -- nothing else in
//  this file hard-codes the brand. Every element is referenced through the
//  stable identifier `platform`, so a rename touches zero structural lines.
// =============================================================================

!const PLATFORM_NAME  "FASTER2.0"
!const PLATFORM_DESC  "Platform to define, verify, test and group computational models over curated datasets, orchestrate their execution lifecycle, govern input data, and expose everything through dashboards and a natural-language agent."

workspace "${PLATFORM_NAME}" "${PLATFORM_NAME} - Regulatory / Risk-Computation Forecasting Platform" {

    !identifiers hierarchical

    model {

        // ---------------------------------------------------------------------
        //  People
        // ---------------------------------------------------------------------
        operator  = person "System Operator"  "Manages and monitors system operation." "Staff"
        developer = person "Model Developer"  "Defines, builds, tests and signs off models on curated datasets under version control." "Staff"
        curator   = person "Data Owner"     "Tracks, verifies, approves / rejects and overrides input data." "Staff"
        analyst   = person "Data Analyst"     "Performs analytics on input and output data across computational runs." "Staff"
        preparer  = person "Data Preparer"    "Uploads and shepherds manual / user-curated data through approval." "Staff"

        // ---------------------------------------------------------------------
        //  The platform  (id = `platform`, display name = ${PLATFORM_NAME})
        // ---------------------------------------------------------------------
        platform = softwareSystem "${PLATFORM_NAME}" "${PLATFORM_DESC}" "Platform" {

            group "User Interfaces" {
                controlCenter    = container "Control Centre" "UI1 - Manage and monitor system operation." "Angular / React" "UI"
                analytics = container "Analytics Dashboard" "UI2 - Inspect input and output of each computational run, compare across runs, day-over-day variance and drill-down." "Power BI / Angular / React" "UI"
                mde       = container "Model Development Environment" "UI3 - Define, build and test models in natural language or Python; exposes the Model Programming Interface (MPI); shows how a definition became executable code; approval / sign-off workflow; version-controlled iteration."  "Angular / React" "UI"
                dataUi    = container "Data Dashboard" "UI4 - Track the status and lineage of input data and link back to its source." "Angular / React" "UI"
                agent     = container "LLM Agent" "UI6 - Natural-language interface able to perform every operation offered by UI1..UI5; intended to progressively replace them." "Teams / Angular / React" "UI"
            }

            group "Backend Services" {
                centerSvc    = container "Control Centre Backend"          "BK1 - Serves the requests that let operators monitor system operations." "Java, OpenAPI, RDBMS" "Backend"
                orchestrator = container "Orchestrator"                    "BK2 - Orchestrates execution of computation models across platforms and manages their lifecycle; supports pluggable executor types (cloud, Treadmill, Databricks, Snowflake, Optimus / RICE)." "Java, OpenAPI, RDBMS" "Backend"
                mdm          = container "Model Development Manager"       "BK6 - Backend for the MDE: model definitions, generated code, MPI resolution, versioning and sign-off." "Java" "Backend"
                llmGateway   = container "LLM Gateway"                     "BK7 - Mediates all communication with LLM models; logs prompts, responses and critical metadata so LLM-driven tasks remain transparent and auditable."  "Java / Python" "Backend"
                datalayer    = container "Datalayer"                       "BK8 - Acquires input data via push, pull, API and streaming; enriches, cleanses, validates and persists it; serves approval / override decisions." "Java / Python" "Backend"
                catalogue    = container "Data Catalogue Provider"         "BK9 - Catalogue of available input data, output data and well-defined models." "Java / Python" "Backend"
                analyticsSvc = container "Data Analytics Service"          "BK10 - Serves curated input and output data for analytics and variance reporting." "Java, Snowflake, DB2" "Backend"
                cache        = container "Caching Layer"                   "BK11 - Shared low-latency cache for catalogue lookups, run status and hot analytics slices." "Redis / In-memory grid" "Backend"
            }

            group "Executors" {
                execDatabricks = container "Databricks Executor"           "BK3 - Lets the Orchestrator execute computation models on Databricks." "Java" "Executor"
                execOptimus    = container "Optimus Executor"              "BK4 - Lets the Orchestrator execute computation models on Optimus." "Java" "Executor"
                execTreadmill  = container "Treadmill Executor"            "BK5 - Lets the Orchestrator execute computation models on Treadmill." "Java" "Executor"
            }

            group "Persistent Storage" {
                analyticsDB = container "Analytical Store"                 "Curated input and output datasets, run results and analytics models." "Snowflake" "Database"
                db2Db       = container "Operational Store"                "System metadata, run lifecycle, model versions, approvals and audit trail." "DB2" "Database"
            }
        }

        // ---------------------------------------------------------------------
        //  Existing external systems
        // ---------------------------------------------------------------------
        financeConnect = softwareSystem "Finance Connect" "Finance wide manual / user-curated data upload tool." "External" {
            finConUI = container "Finance Connect Portal" "UI5 - Upload and manage the approval workflow for manual data needed by the forecasting system." "Angular / React" "UI"
            finConService = container "Finance Connect Service" "" "Java/Spring Boot"
            finConDB = container "User Curated Data Store" "Snowflake" "Database" 
        }
        optimus        = softwareSystem "Optimus"         "Firm-internal distributed execution platform." "External"
        treadmill      = softwareSystem "Treadmill"       "Firm-internal cloud execution service." "External"
        databricks     = softwareSystem "Databricks"      "Firm-external distributed execution platform." "External"
        snowflake      = softwareSystem "Snowflake"       "Firm-external data storage and warehousing platform." "External"
        sourceSystems  = softwareSystem "Source Systems"  "Upstream systems supplying raw input data via push, pull, API and streaming." "External"
        llmProvider    = softwareSystem "LLM Provider"    "Large language models used for natural-language interaction and model code generation." "External"

        // ---------------------------------------------------------------------
        //  People -> interfaces
        // ---------------------------------------------------------------------
        operator  -> platform.controlCenter    "Monitors and operates the platform" "HTTPS"
        developer -> platform.mde       "Defines, tests and signs off models" "HTTPS"
        curator   -> platform.dataUi    "Tracks, approves / rejects and overrides data" "HTTPS"
        analyst   -> platform.analytics "Explores runs, variances and drill-downs" "HTTPS"
        preparer  -> financeConnect.finConUI     "Uploads manual data for approval" "HTTPS"

        operator  -> platform.agent     "Operates the platform in natural language" "Teams / HTTPS"
        developer -> platform.agent     "Authors and queries models in natural language" "Teams / HTTPS"
        curator   -> platform.agent     "Reviews and overrides data in natural language" "Teams / HTTPS"
        analyst   -> platform.agent     "Asks analytical questions in natural language"  "Teams / HTTPS"

        // ---------------------------------------------------------------------
        //  UI -> backend
        // ---------------------------------------------------------------------
        platform.controlCenter    -> platform.centerSvc    "Reads system and run status"              "HTTPS / OpenAPI"
        platform.analytics -> platform.analyticsSvc "Queries run, comparison and variance data" "HTTPS / OpenAPI"
        platform.mde       -> platform.mdm          "Submits model definitions, reviews generated code, signs off" "HTTPS / OpenAPI"
        platform.dataUi    -> platform.datalayer    "Reads input data status, records approvals and overrides"     "HTTPS / OpenAPI"
        financeConnect.finConUI     -> platform.datalayer    "Publishes approved user curated datasets"       "HTTPS / OpenAPI"
        platform.agent     -> platform.llmGateway   "Sends natural-language requests"          "HTTPS"

        // ---------------------------------------------------------------------
        //  Agent fan-out (UI6 can drive every capability)
        // ---------------------------------------------------------------------
        platform.llmGateway -> platform.centerSvc    "Invokes monitoring operations"        "HTTPS / OpenAPI"
        platform.llmGateway -> platform.mdm          "Invokes model development operations" "HTTPS / OpenAPI"
        platform.llmGateway -> platform.datalayer    "Invokes data governance operations"   "HTTPS / OpenAPI"
        platform.llmGateway -> platform.analyticsSvc "Invokes analytics operations"         "HTTPS / OpenAPI"
        platform.llmGateway -> platform.catalogue    "Resolves datasets and models for grounding" "HTTPS / OpenAPI"
        platform.llmGateway -> llmProvider           "Prompts models and captures auditable metadata" "HTTPS"
        platform.llmGateway -> platform.db2Db        "Persists prompts, responses and traceability metadata" "JDBC"

        // ---------------------------------------------------------------------
        //  Control centre and orchestration
        // ---------------------------------------------------------------------
        platform.centerSvc -> platform.orchestrator "Queries and controls run lifecycle" "HTTPS / OpenAPI"
        platform.centerSvc -> platform.db2Db        "Reads system and category metadata" "JDBC"
        platform.centerSvc -> platform.cache        "Caches run status"                  "RESP"

        platform.mdm -> platform.catalogue    "Resolves datasets and standard calculation blocks (MPI)" "HTTPS / OpenAPI"
        platform.mdm -> platform.llmGateway   "Generates executable code from model definitions"        "HTTPS"
        platform.mdm -> platform.orchestrator "Submits models for test and production execution"        "HTTPS / OpenAPI"
        platform.mdm -> platform.db2Db        "Persists model versions, approvals and audit trail"      "JDBC"

        platform.orchestrator -> platform.execDatabricks "Dispatches execution"                 "Internal API"
        platform.orchestrator -> platform.execOptimus    "Dispatches execution"                 "Internal API"
        platform.orchestrator -> platform.execTreadmill  "Dispatches execution"                 "Internal API"
        platform.orchestrator -> platform.db2Db          "Persists run lifecycle and category (CCAR / NSFR / LCR) state" "JDBC"
        platform.orchestrator -> platform.datalayer      "Requests the input datasets required by a run" "HTTPS / OpenAPI"

        platform.execDatabricks -> databricks "Runs computation models" "Databricks API"
        platform.execOptimus    -> optimus    "Runs computation models" "Optimus API"
        platform.execTreadmill  -> treadmill  "Runs computation models" "Treadmill API"

        // ---------------------------------------------------------------------
        //  Data
        // ---------------------------------------------------------------------
        sourceSystems  -> platform.datalayer "Delivers raw input data"               "Push / Pull / API / Streaming"
        financeConnect -> platform.datalayer "Delivers approved manual datasets"     "API / File"
        financeConnect.finConUI -> financeConnect.finConService "Manages manual upload and approval"    "HTTPS"

        platform.datalayer -> platform.analyticsDB "Writes enriched, cleansed input data" "Snowflake SQL"
        platform.datalayer -> platform.db2Db       "Writes data status, approvals and overrides" "JDBC"
        platform.datalayer -> platform.cache       "Caches hot reference data"        "RESP"

        platform.catalogue -> platform.analyticsDB "Reads input / output dataset metadata" "Snowflake SQL"
        platform.catalogue -> platform.db2Db       "Reads model and category metadata"     "JDBC"
        platform.catalogue -> platform.cache       "Caches catalogue lookups"              "RESP"

        platform.analyticsSvc -> platform.analyticsDB "Queries run inputs and outputs" "Snowflake SQL"
        platform.analyticsSvc -> platform.db2Db       "Queries run and model metadata"  "JDBC"
        platform.analyticsSvc -> platform.cache       "Caches analytics slices"         "RESP"

        platform.analyticsDB -> snowflake "Hosted on" "Snowflake"
    }

    views {

        systemLandscape "Landscape" {
            include *
            autolayout tb
            description "${PLATFORM_NAME} in the landscape of its users and the firm's existing execution and data platforms."
        }

        systemContext platform "SystemContext" {
            include *
            autolayout tb
            description "Users of ${PLATFORM_NAME} and the external systems it integrates with."
        }

        container platform "Containers" {
            include *
            autolayout lr
            description "User interfaces, backend services, executors and storage that make up ${PLATFORM_NAME}."
        }

        container platform "ModelDevelopment" {
            include developer platform.mde platform.mdm platform.llmGateway platform.catalogue platform.orchestrator platform.db2Db llmProvider
            autolayout lr
            description "Slice: defining, generating, verifying and signing off a model."
        }

        container platform "DataGovernance" {
            include curator preparer platform.dataUi financeConnect.finConUI platform.datalayer platform.catalogue platform.analyticsDB platform.db2Db financeConnect sourceSystems
            autolayout lr
            description "Slice: acquisition, enrichment, verification, approval and override of input data."
        }

        container platform "Execution" {
            include platform.centerSvc platform.orchestrator platform.execDatabricks platform.execOptimus platform.execTreadmill platform.datalayer platform.db2Db databricks optimus treadmill
            autolayout lr
            description "Slice: orchestration of computational runs across execution platforms."
        }

        dynamic platform "ModelRun" "Model definition to executed run" {
            developer -> platform.mde "Authors a model definition in natural language or Python"
            platform.mde -> platform.mdm "Submits the definition for code generation"
            platform.mdm -> platform.catalogue "Resolves datasets and standard calculation blocks (MPI)"
            platform.mdm -> platform.llmGateway "Requests executable code generation"
            platform.llmGateway -> llmProvider "Prompts the model and captures metadata"
            platform.mdm -> platform.db2Db "Stores the version and the sign-off"
            platform.mdm -> platform.orchestrator "Submits the approved model for execution"
            platform.orchestrator -> platform.datalayer "Requests the required input datasets"
            platform.orchestrator -> platform.execDatabricks "Dispatches execution"
            platform.execDatabricks -> databricks "Runs the computation model"
            platform.orchestrator -> platform.db2Db "Records run lifecycle state"
            platform.analyticsSvc -> platform.analyticsDB "Reads the run output"
            platform.analytics -> platform.analyticsSvc "Presents results and variances"
            analyst -> platform.analytics "Reviews the run"
            autolayout lr
        }

        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                shape Person
                background #0b4f6c
                color #ffffff
            }
            element "Software System" {
                background #1168bd
            }
            element "Platform" {
                background #0b3d91
            }
            element "External" {
                background #8c8c8c
                color #ffffff
            }
            element "Container" {
                background #438dd5
            }
            element "UI" {
                shape WebBrowser
                background #2e7d32
            }
            element "Backend" {
                shape RoundedBox
                background #1565c0
            }
            element "Executor" {
                shape Hexagon
                background #6a1b9a
            }
            element "Database" {
                shape Cylinder
                background #b26500
            }
            element "Group" {
                color #444444
            }
            relationship "Relationship" {
                thickness 2
                routing Orthogonal
            }
        }

        theme default
    }
}
