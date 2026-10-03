# 'Dhruva' Platform Specifications

High Level system definition capable of doing the following: 
1. Provide a subset of users with an environment where they can define, verify and test computations/algorithms (*also called as models*) on well defined and curated datasets. Version control and approval workflow already build in to support marking a version fit for production use and to provide audit trail of changes.  
2. Provide same or a different subset of users with capability to group these computations together into a catogaries (like CCAR/NSFR/LCR/6G/RFM etc) and manage and visualize their processing lifecycle as a single unit.
3. Provide same or a different subset of users with capability to visualize, track, verify, approve/reject and override the input data.
4. Provide same of a different subset of users with capability to carry out analytics on both input and output data. 
5. Provide users with an agent to interact with, this will serve as an alternate, natural language based interface for users. This will users to perform all the operations as above using natural language. 

## Basic Premise
Prepare a system architecture which structrizr system can parse, with following parameters

## System Components 
1. **User interfaces**: Following components will allow users to interact with the system. 

----------------------

|#|Component Name|Description|Tech Stack|Related Components|
|-|--------------|-----------|----------|------------------|
|UI1|Control Centre|Manage and monitor system operation.|Angular/React|
|UI2|Analytics Dashboard|Access the input and output for each computational run, compare and contrast data across runs, carry out day-over-day variances and drill down into data if needed|Power BI/Angular/React|
|UI3|Model Development Environment (MDE)|1. A portal that allows users to define, build and test models. 2. Allows users to define models both in Natural languate as well as languages like Python. 3. Provides users with visibility into how each model definition document was converted into executable code. 4. Provides model developers with Model Programming Interface (MPI) for defining data sets and standarad calculation blocks. 5. Provides an approval workflow where authorized users can test and verify the final generated code and provide sign-off if it meets their standards. 4. Allows users to iterate over the whole process of model development by make changes to the model definition file multiple time to arrive at a final stage, while tracking each file inolved with version control.|Angular/React|
|UI4|Input Data Dashboard|Allow users to tack status of input data, link to |Angular/React|
|UI5|Finance Connect|Allow users to upload and manage approval workflow for manual data needed for the forcasting system.|Angular/React|
|UI6|LLM Agent (Teams/Others)|All the operation performed by users in UI1..UI5 can also be performed by asking the Agent in plain english, at sometime in near future, replace UI1..UI5 with UI6 once users are comfortable|Teams/Angular/React/Internal Platforms|



2. **Backend Components**: Following represent the backend components of the system. 

|#|Component Name|Description|Tech Stack|Related Components|
|-|--------------|-----------|----------|------------------|
|BK1|Control Centre backend|Java based process that serves requests that allow users to monitor system operations|JAVA, OPEN API, RDBMS|UI1|
|BK2|Orchestrator|Orchestrates the execution of computation models on various platforms and manages their lifecycle. Allows definition of multiple types of executors for example cloud, treadmill (internal cloud), Databricks, Snowflake, Optimus/RICE|JAVA, OPEN API, RDBMS|BK1|
|BK3|Databricks Executor|Allow orchestrator to execute computation models on databricks|Java|BK2|
|BK4|Optimus Executor|Allow orchestrator to execute computation models on Optimus|Java|BK2|
|BK5|Treadmill Executor|Allow orchestrator to execute computation models on treadmill|Java|BK2|
|BK6|Model Development Manager (MDM)|Supports the MDE(UI3)|JAVA|BK7,UI3|
|BK7|LLM Gateway|Manages communications with LLM modes, logs and saves critical metadata to enable the system to provide transparency to users with transparency in LLM related tasks|Java/Python|BK7,UI6|
|BK8|Datalayer|Responsible for managing the input data that is needed for models to process. 1. Receive the input data via different mechanishms like push, pull, api hit, streaming etc. 2. Enrich/cleanse the data if needed. 3. 
|BK9|Data Catalogue Provider|Provides users with 1. A catalogue of input data available for user in model execution 2. A catalogue of output data available 3. A catalogue of well defined models|Java/Python|BK8,UI3|
|BK10|Data Analytics service|Provde data for analytics|Snowflake, DB2|UI2|
|BK11|Caching layer|

3. **Storage**: 
Persistent Storage will consist of snowflake and DB2.


4. **External** already existing systems
    1. **Fianace Connect** - Firm Internal Maunal/User Curated data upload tool
    2. **Optimus** - Firm Internal Distributed execution platform
    3. **Treadmill** - Firm internal cloud execution service
    4. **Databricks** - Firm External distributed execution platform
    5. **Snowflake** - Firm External Data storage platform

