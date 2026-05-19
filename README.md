# Bonial_CaseStudy
This repo contains Case study assigment results.

Scenario
A growing company manages Projects (Project__c) linked to Accounts. The business needs better automation, data integrity, and UI visibility. Your solution must follow Salesforce best practices and handle large data volumes.

Task 1: Configuration & Data Model
1. Create custom object Project__c (Lookup to Account). 2. Fields:
- Status__c (Picklist: Planned, Active, Completed)
- Budget__c (Currency) 3. Add field on Account:
- Total_Projects__c (Number) 4. Validation Rule:
- Budget must be > 0 when Status = 'Active' (on project) 5.
- Consider edge cases that you can think of:

Task 2: Apex Trigger & Logic
Build a bulk-safe solution to maintain Total_Projects__c on Account.
Requirements:
- Use a Trigger + Handler class
- Handle large data volumes (200+ records)
- Ensure correct behavior when Project is re-parented

Task 3: Apex Test Class
Write a comprehensive test class:
- Insert Projects
- Delete Projects
- Update Project Account (re-parenting) - Bulk test (200 records)
- Edge cases (no Account)
- Aim for meaningful coverage (not just %)
 
Task 4: Lightning Web Component (LWC)
Build an LWC for Account Record Page:
Features:
- Display Account details (Name, Total Projects) - Show related Projects in a table
- Filter Projects by Status
- Show only Active Projects toggle option
- Pagination or lazy loading
