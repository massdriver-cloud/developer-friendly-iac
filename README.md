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
