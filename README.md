# **Building Developer-Friendly IaC with OpenTofu**

## **Workshop Overview**

Infrastructure as Code (IaC) is at the core of modern cloud development, but too often, it creates friction for developers. This workshop explores how to design **developer-friendly IaC modules** that abstract complexity while enforcing your organization’s operational standards.

We’ll walk through the principles of **Use-Case-Oriented Design (UCOD)** using a practical example: an S3 bucket module for **Application Asset Storage**. Along the way, we’ll demonstrate how thoughtful abstractions reduce cognitive load, scale organizational standards, and improve developer experience (DevEx).

The starting [state of this module](./base) reflects a common, anemic approach to Infrastructure as Code. It exposes nearly every S3 configuration detail as variables, requiring users to make low-level decisions about lifecycle rules, versioning, and public access settings. This design lacks meaningful abstractions, leaving all responsibility for consistency and compliance on the user. While this pattern is widespread, it results in harder-to-maintain code, misconfigurations, and increased operational overhead. In the labs, we’ll evolve this module to embed organizational policies, streamline the interface, and provide a more developer-friendly experience.

### **S3 Use Cases: More Than Storage**

S3 buckets serve a variety of purposes across teams and applications, including but not limited to:

- **Logging Buckets:** Centralized logs for auditing, debugging, or compliance.
- **ETL Landing Zones:** Staging data for transformation workflows or analytics pipelines.
- **Application Asset Storage:** Hosting user-generated content, application resources, or media files.
  
Each use case has unique operational requirements, and tailoring IaC modules to meet those requirements is critical for scaling across teams.

---

## **Application Asset Storage Module**

Application asset storage refers to buckets that hold **user-generated or app-related content**, such as:

- **Images, videos, or audio:** Uploaded by end-users (e.g., profile pictures or media).
- **Documents:** Shared between users or processed by the application (e.g., PDFs or reports).
- **Miscellaneous assets:** Any additional files the application needs, stored long-term or accessed frequently.

These buckets are critical to the functionality of many applications, so enforcing **consistent policies** ensures that storage meets the organization’s standards for:

- **Cost-efficiency:** Optimizing resources while maintaining necessary access patterns.
- **Data reliability:** Preventing accidental data loss.
- **Security:** Ensuring access is controlled and data is encrypted.

---

Here’s the updated structure with consistent sections for both Lab 1 and Lab 2:

---

## **Labs**

Each lab directory contains a complete Terraform module for the use case described in the lab.

### **[Lab 1: Operational Abstractions](./lab1)**

In this lab, we’ll step into the role of the ops team to codify our organization’s **non-negotiable rules** for managing application asset storage.

---

#### **Our Business Rules**

As an organization, we prioritize **data durability** and **cost-effective, secure storage**. 

The following non-negotiables are embedded into this module as hardcoded values or operational abstractions:

---

##### **Buckets Cannot Be Deleted Accidentally**
- Requires buckets to be emptied before deletion, ensuring data is never deleted unintentionally.

---

##### **Retention Policies Are Mandatory**
All buckets must enforce one of the following retention policies:
- **Ephemeral:** Data deleted after 7 days.
- **Short-term:** Data deleted after 30 days.
- **Standard:** Data transitions to cost-optimized storage after 90 days.
- **Archival:** Data transitions to Glacier storage after 1 day.
- **Permanent:** No expiration or transitions.

---

##### **Access Control Defaults to Private**
- All buckets are private by default to ensure data is not exposed unintentionally.

---

#### **Business Context**

These hardcoded rules ensure **organizational standards** are consistently applied while reducing the risk of misconfiguration. They also provide **guardrails** for developers, ensuring the infrastructure aligns with operational policies.

---

#### **Expected Outcome**

By the end of this lab, your module will:
- Enforce **mandatory retention policies** for all buckets.
- Prevent accidental deletion of buckets with the **force_destroy** safeguard.
- Ensure all buckets are **private by default**, reducing data exposure risks.

You’ll see how embedding **operational abstractions** creates a foundation of organizational policies that scales across teams.

---

### **[Lab 2: Survey-Based Inputs](./lab2)**

In this lab, we’ll extend the Application Asset Storage module to better reflect how an ops team collaborates with developers to create infrastructure tailored to their needs.

---

#### **Our Business Rules**

As an organization, we aim to make buckets easy for developers to configure while maintaining guardrails that align with operational requirements. The following **survey-based inputs** have been introduced to simplify developer decision-making:

---

##### **Versioning Policies**
Developers select from predefined policies to manage object versioning:
- **None:** No versioning applied.  
- **Persistent:** Keeps all object versions indefinitely.  
- **Audit:** Retains non-current object versions for one year.  

---

##### **Notifications for Events**
Developers can specify a list of S3 events (e.g., `s3:ObjectCreated:*`, `s3:ObjectRemoved:*`) to trigger notifications.  
- An SNS topic is automatically created for event notifications.  
- This simplifies building event-driven workflows while ensuring consistency in notification setup.

---

#### **Business Context**

By embedding these survey-based inputs into the module, we’re providing developers with an interface that aligns with their needs without exposing the complexity of underlying S3 configurations. This approach improves **developer experience** while reducing operational overhead.

---

#### **Expected Outcome**

By the end of this lab, your module will:
- Offer **developer-friendly versioning policies** to manage object retention.  
- Automatically configure SNS notifications for specified event types, reducing the need for manual setup.  

This lab demonstrates how **survey-based inputs** bridge the gap between operational expertise and developer workflows.

### **[Lab 3: Use-Case Presets](./lab3)**

#### **Objective**

In this lab, we’ll learn how **use-case presets** can simplify the adoption of IaC modules by providing developers with pre-defined configurations tailored to common scenarios. Presets allow teams to encode operational expertise into `.tfvars` files, offering a quick starting point for developers to address the 'blank slate' problem.

---

### **What You'll Do**

1. **Create Use-Case Presets:**  
   - You'll create `.tfvars` files that define configurations for specific use cases of the Application Asset Storage module.
   - For example, you might configure a bucket for **User Profile Pictures** or **Temporary File Uploads**.

2. **Understand How Presets Work:**  
   - Learn how `.tfvars` files can encode organizational standards into easily reusable templates.
   - See how developers can use these presets as a starting point, customizing them as needed for specific workloads.

---

### **Business Context**

Use-case presets reduce the cognitive load for developers by providing thoughtfully designed, pre-configured options. They help achieve:

- **Faster Onboarding:** New developers can start using IaC modules without needing deep operational knowledge.
- **Consistency:** Presets ensure that organizational standards are applied consistently across different teams and projects.
- **Efficiency:** Ops teams can encode their expertise once, reducing the need for repeated consultations or support.

---

#### **Presets We’ll Create**

1. **User Profile Pictures**  
   - Indefinite retention policy for long-term storage.  
   - Persistent versioning to retain all changes to files.  
   - Notifications enabled for object creation events.

2. **Temporary File Uploads**  
   - Ephemeral retention policy with files deleted after 7 days.  
   - No versioning since changes or overwrites aren't tracked.  
   - Notifications disabled to reduce unnecessary overhead.

---

### **Expected Outcome**

By the end of this lab, your module will have:  
1. A set of `.tfvars` files representing common use cases for the Application Asset Storage module.  
2. A clear understanding of how presets enable developer-friendly IaC while maintaining operational guardrails.

This lab demonstrates how **use-case presets** align developer needs with organizational standards, creating a seamless balance between flexibility and control.

### **[Lab 4: Derived Naming and Tags](./lab4)**

#### **Objective**

In this lab, we’ll design a submodule to standardize **naming conventions** and **tagging** for all resources. By centralizing these patterns, we’ll ensure resources are identifiable, compliant with organizational standards, and easy to manage across projects and teams.

---

### **What You'll Do**

1. **Create a Naming and Tagging Submodule:**  
   - You’ll build a reusable submodule that takes common inputs such as project name, environment, and resource name.
   - The submodule will generate a consistent `name_prefix` and include a random suffix to ensure uniqueness.
   - Additionally, the submodule will return a standardized set of tags based on these inputs.

2. **Explore Practical Applications:**  
   - Understand why consistent naming and tagging conventions matter for resource discovery, cost allocation, and compliance.
   - Learn how this submodule can be integrated into other modules to eliminate repetitive work and human error.

---

### **Business Context**

Naming and tagging resources consistently is crucial for any organization’s cloud infrastructure. A well-designed system provides:

- **Discoverability:** Easily identify resources across environments and projects.  
- **Cost Attribution:** Track cloud expenses back to specific teams or projects.  
- **Compliance:** Ensure all resources meet tagging policies for audits and governance.  

---

### **Inputs and Outputs**

The submodule will use the following **inputs**:  
- **`project`**: The project or application the resource belongs to.  
- **`environment`**: The environment/stage (e.g., `prod`, `qa`, `staging`).  
- **`name`**: A name for this instance of the module (e.g., `session-cache`, `page-cache`).  
- **`team`**: The team responsible for the resource (optional but recommended). 

The submodule will output:  
- **`name_prefix`**: A consistent name for resources based on the inputs, formatted as `project-env-name-suffix`.  
- **`suffix`**: A randomly generated 4-character string to ensure uniqueness.  
- **`tags`**: A map of key-value pairs including all the inputs above.

---

### **Opinionated Notes**

- **Avoid Overloading Names**: Some organizations like to include additional information, such as the region or org name (`myorg-prod-us-east`). This can clutter names unnecessarily since the ARN already contains the region and account details.  
- **Random Suffixes**: Adding a random suffix prevents naming collisions without polluting the prefix. This is especially useful for resources like S3 buckets or DynamoDB tables that require globally unique names.  
- **Minimal Inputs, Maximum Clarity**: Only include meaningful inputs that add value to the resource’s name or tags. Avoid unnecessary verbosity.  
- **Don't Include Team in Name**: Teams can change ownership of projects, but most cloud resources cannot be renamed. For attributes that are subject to change but still need to be included, use tags instead of embedding them in resource names.

---

### **Expected Outcome**

By the end of this lab, your submodule will:  
1. Accept `project`, `environment`, `name`, and `team` as inputs.  
2. Generate a consistent `name_prefix` and random `suffix` for resource uniqueness.  
3. Produce a standardized map of `tags` for downstream modules to use.
4. Set names and tags for all resources in the root module from the child modules outputs.

This submodule will provide a reusable foundation for your IaC ecosystem, promoting **clarity, consistency, and scalability**.  

### **[Lab 5: IAM Policies as Outputs](./lab5)**

#### **Objective**

In this lab, we’ll extend the Application Asset Storage module to output granular IAM policies that developers and applications can use to interact with the bucket. These policies will encode best practices for secure access while allowing flexibility for various use cases, such as read-only access, CRUD operations, and notification subscriptions.

---

### **What You'll Do**

1. **Define Granular IAM Policies**:  
   - Create and output three IAM policies tailored to specific use cases:
     - **Read Policy**: Grants read-only access, including the ability to list objects in the bucket.
     - **CRUD Policy**: Grants full control over bucket objects (create, read, update, delete).
     - **Subscribe Policy**: Grants permission to publish notifications to an SNS topic (if notifications are enabled).

2. **Output Policies**:  
   - Instead of exposing raw JSON policy documents, the module will output a map of IAM policy ARNs, making it easy for downstream modules or applications to attach the appropriate policies.

---

#### **Business Context**

Applications and teams often need distinct levels of access to the same bucket. By providing pre-defined IAM policies as outputs, we:  

- **Reduce Risk**: Developers can only select from pre-approved access levels, minimizing the risk of over-permissioning.  
- **Encourage Best Practices**: Teams don’t need to manually craft IAM policies, reducing errors and promoting consistency.  
- **Streamline Integration**: Policies are ready to attach to roles or users without additional setup.  

---

#### **IAM Policies**

The following policies will be available as outputs:

---

##### **Read Policy**
Grants read-only access, including the ability to list objects:  
- **Use Case**: Applications or services that need to fetch and display objects without modifying them.  
- **Actions**:  
  - `s3:GetObject`  
  - `s3:ListBucket`  

---

##### **CRUD Policy**
Grants full control over bucket objects:  
- **Use Case**: Services or applications that create, read, update, and delete objects.  
- **Actions**:  
  - `s3:GetObject`  
  - `s3:ListBucket`  
  - `s3:PutObject`  
  - `s3:DeleteObject`  

---

##### **Subscribe Policy**
Grants the ability to publish notifications to the SNS topic (if notifications are enabled):  
- **Use Case**: Event-driven workflows that need to act on bucket changes.  
- **Actions**:  
  - `sns:Publish`  

---

### **Expected Outcome**

By the end of this lab, your module will:  
1. Output a map of IAM policy ARNs (`policies`) with keys for `read`, `crud`, and `subscribe`.  
2. Automatically include the `subscribe` policy if event notifications are configured.  

This lab demonstrates how **IAM policies as outputs** enhance modularity, security, and ease of integration, making it simple for developers to attach the correct policies to their applications.  

### **[Lab 6: Using Airlock and JSON Schemas](./lab6)**

#### **Objective**

In this lab, we’ll integrate **[Airlock](https://github.com/massdriver-cloud/airlock)** to manage inputs and outputs using **JSON Schemas**. This approach reduces boilerplate, creates consistent contracts between modules, and enables validation to catch breaking changes early in the development lifecycle.

---

#### **What You'll Do**

1. **Generate Input Schemas**:
   - Replace `.tfvars` files with a JSON schema for your module’s variables.
   - Use Airlock to automatically generate `variables.json` and synchronize it with Terraform.

2. **Embed the Naming Module Schema**:
   - Generate a schema for the **naming module** and reference it in the main module.
   - Move naming-related variables into a `metadata` object and formalize them using a shared schema.

3. **Create Output Schemas**:
   - Define structured outputs for the S3 bucket, including attributes like `ARN` and IAM `policies`.
   - Use JSON schemas to validate and document the outputs.

4. **Integrate Airlock into CI**:
   - Automate schema generation and validation in your CI/CD pipeline to ensure consistency and detect breaking changes early.

Quick tutorial on how to use Airlock CLI

```shell
# Locally generate the schema for the inputs and commit to the repo
airlock opentofu input ./path/to/your/module > variables.json

# 'variables.json' is now your interface to your modules

# In CI (or you can generate with precommit if you dont want to run this in CI) to generate the variables.tf
airlock opentofu output variables.json > variables.tf

# Validate inputs with all the power of JSON schema validation and $refs
airlock validate -d my-environment.tfvars.json -s variables.json

# Validate contracts between modules
tofu apply
tofu output -json | jq .bucket.value > bucket-artifact.json
airlock validate -d bucket-artifact.json -s contracts/bucket.json
```
---

#### **Our Business Rules**

As an organization, we prioritize **consistency** and **maintainability** in our Infrastructure as Code. JSON schemas help us enforce contracts and automate the tedious management of variables and outputs.

---

##### **Schemas for Inputs**
- Inputs are defined as a JSON schema (`variables.json`) that captures the structure and validation of all module variables.
- These schemas replace `.tfvars` files and ensure input consistency.

---

##### **Schemas for Outputs**
- Outputs are formalized into a structured schema (`outputs.json`), defining a clear contract for downstream modules.
- Example: The `bucket` output includes an `ARN` key and a `policies` map for IAM policy ARNs.

---

##### **Shared Schemas**
- Shared schemas (`$ref`) eliminate duplication for common structures like metadata or outputs.
- Example: The `metadata` schema, used across multiple modules, standardizes naming and tagging conventions.

---

#### **Business Context**

Integrating **Airlock** and JSON schemas into your workflow unlocks significant benefits:

- **Contracts, Not Guesswork**: Inputs and outputs become clear, documented contracts, reducing ambiguity for module consumers.  
- **Automation**: Airlock automates schema generation and Terraform synchronization, reducing human error.  
- **Pre-Production Validation**: Catch breaking changes early with schema validation in CI pipelines.  
- **Reusable Components**: Shared schemas streamline collaboration and ensure consistency across your IaC ecosystem.

---

#### **Expected Outcome**

By the end of this lab, your module will:

1. Replace `.tfvars` files with a JSON schema for inputs.
2. Formalize outputs like the S3 bucket and IAM policies into a schema.
3. Embed the naming module schema into the main module, eliminating redundant definitions.
4. Automate schema generation and validation using Airlock in CI/CD pipelines.

This lab demonstrates how **Airlock and JSON Schemas** simplify infrastructure management while enhancing consistency and scalability across teams.  
