/*
AI-Powered Student Support Analytics
SQL Analysis Queries

Dataset: simulated_student_support_inquiries.csv
Note: All records are simulated for academic portfolio analysis.
The queries below use common PostgreSQL-style SQL syntax.
*/

-- 1. Total number of inquiries
SELECT COUNT(*) AS total_inquiries
FROM student_support_inquiries;

-- 2. Inquiry volume by category
SELECT
    Category,
    COUNT(*) AS inquiry_count
FROM student_support_inquiries
GROUP BY Category
ORDER BY inquiry_count DESC;

-- 3. Inquiry volume by department
SELECT
    Department,
    COUNT(*) AS inquiry_count
FROM student_support_inquiries
GROUP BY Department
ORDER BY inquiry_count DESC;

-- 4. Average response time by department
SELECT
    Department,
    ROUND(AVG(Response_Hours), 2) AS avg_response_hours
FROM student_support_inquiries
GROUP BY Department
ORDER BY avg_response_hours DESC;

-- 5. Average resolution time by department
SELECT
    Department,
    ROUND(AVG(Resolution_Hours), 2) AS avg_resolution_hours
FROM student_support_inquiries
GROUP BY Department
ORDER BY avg_resolution_hours DESC;

-- 6. Open or unresolved inquiries
SELECT
    Inquiry_ID,
    Date,
    Category,
    Department,
    Urgency,
    Status,
    Response_Hours,
    Resolution_Hours
FROM student_support_inquiries
WHERE Status <> 'Resolved'
ORDER BY Date;

-- 7. High-urgency inquiries
SELECT
    Inquiry_ID,
    Date,
    Category,
    Department,
    Root_Cause,
    Response_Hours,
    Resolution_Hours
FROM student_support_inquiries
WHERE Urgency = 'High'
ORDER BY Response_Hours DESC;

-- 8. Most common root causes
SELECT
    Root_Cause,
    COUNT(*) AS issue_count
FROM student_support_inquiries
GROUP BY Root_Cause
ORDER BY issue_count DESC;

-- 9. Repeat-contact analysis by category
SELECT
    Category,
    COUNT(*) AS repeat_contacts
FROM student_support_inquiries
WHERE Repeat_Contact = 1
GROUP BY Category
ORDER BY repeat_contacts DESC;

-- 10. Overall repeat-contact rate
SELECT
    ROUND(100.0 * SUM(Repeat_Contact) / COUNT(*), 2) AS repeat_contact_rate_pct
FROM student_support_inquiries;

-- 11. Misrouted cases by department
SELECT
    Department,
    COUNT(*) AS misrouted_cases
FROM student_support_inquiries
WHERE Current_State_Misrouted = 1
GROUP BY Department
ORDER BY misrouted_cases DESC;

-- 12. Overall misroute rate
SELECT
    ROUND(100.0 * SUM(Current_State_Misrouted) / COUNT(*), 2) AS misroute_rate_pct
FROM student_support_inquiries;

-- 13. Average satisfaction score by category
SELECT
    Category,
    ROUND(AVG(CSAT), 2) AS avg_csat
FROM student_support_inquiries
GROUP BY Category
ORDER BY avg_csat ASC;

-- 14. Monthly inquiry trend
SELECT
    DATE_TRUNC('month', CAST(Date AS DATE)) AS month,
    COUNT(*) AS inquiry_count
FROM student_support_inquiries
GROUP BY DATE_TRUNC('month', CAST(Date AS DATE))
ORDER BY month;

-- 15. Volume and average resolution time by category
SELECT
    Category,
    COUNT(*) AS inquiry_count,
    ROUND(AVG(Resolution_Hours), 2) AS avg_resolution_hours
FROM student_support_inquiries
GROUP BY Category
ORDER BY avg_resolution_hours DESC;

-- 16. Compare repeat vs. non-repeat contacts
SELECT
    Repeat_Contact,
    COUNT(*) AS inquiry_count,
    ROUND(AVG(Response_Hours), 2) AS avg_response_hours,
    ROUND(AVG(Resolution_Hours), 2) AS avg_resolution_hours,
    ROUND(AVG(CSAT), 2) AS avg_csat
FROM student_support_inquiries
GROUP BY Repeat_Contact;

-- 17. Urgency distribution
SELECT
    Urgency,
    COUNT(*) AS inquiry_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM student_support_inquiries
GROUP BY Urgency
ORDER BY inquiry_count DESC;

-- 18. Channel performance
SELECT
    Channel,
    COUNT(*) AS inquiry_count,
    ROUND(AVG(Response_Hours), 2) AS avg_response_hours,
    ROUND(AVG(Resolution_Hours), 2) AS avg_resolution_hours,
    ROUND(AVG(CSAT), 2) AS avg_csat
FROM student_support_inquiries
GROUP BY Channel
ORDER BY inquiry_count DESC;

-- 19. Categories with both high volume and long resolution time
SELECT
    Category,
    COUNT(*) AS inquiry_count,
    ROUND(AVG(Resolution_Hours), 2) AS avg_resolution_hours
FROM student_support_inquiries
GROUP BY Category
HAVING COUNT(*) >= 100
ORDER BY avg_resolution_hours DESC, inquiry_count DESC;

-- 20. Simple business-priority classification using CASE
SELECT
    Inquiry_ID,
    Category,
    Urgency,
    Response_Hours,
    CASE
        WHEN Urgency = 'High' AND Response_Hours > 6 THEN 'Immediate Attention'
        WHEN Current_State_Misrouted = 1 THEN 'Routing Review'
        WHEN Repeat_Contact = 1 THEN 'Follow-up Needed'
        ELSE 'Standard'
    END AS business_priority
FROM student_support_inquiries;
