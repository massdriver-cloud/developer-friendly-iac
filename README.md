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