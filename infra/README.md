# Queries

## Log Analytics Queries
### Retrieve Agent consumption by API subscription
```KQL
let usePreviousMonth = false;  // true = Last month, false = Current month
let targetMonth = iff(usePreviousMonth, startofmonth(ago(30d)), startofmonth(now()));
let nextMonth = endofmonth(targetMonth) + 1d;
AppMetrics
| where Name in ("Completion Tokens", "Prompt Tokens", "Total Tokens")
| extend SubscriptionID = tostring(Properties["Subscription ID"])
| where TimeGenerated >= targetMonth and TimeGenerated < nextMonth
| summarize CompletionTokens = sumif(Sum, Name == "Completion Tokens"),
            PromptTokens = sumif(Sum, Name == "Prompt Tokens"),
            TotalTokens = sumif(Sum, Name == "Total Tokens")
    by TimeGenerated, SubscriptionID
```
### Summarize Agent consumption by API subscription per day
```KQL
let usePreviousMonth = false;  // true = Last month, false = Current month
let targetMonth = iff(usePreviousMonth, startofmonth(ago(30d)), startofmonth(now()));
let nextMonth = endofmonth(targetMonth) + 1d;
AppMetrics
| where Name in ("Completion Tokens", "Prompt Tokens", "Total Tokens")
| extend SubscriptionID = tostring(Properties["Subscription ID"])
| where TimeGenerated >= targetMonth and TimeGenerated < nextMonth
| summarize CompletionTokens = sumif(Sum, Name == "Completion Tokens"),
            PromptTokens = sumif(Sum, Name == "Prompt Tokens"),
            TotalTokens = sumif(Sum, Name == "Total Tokens")
        by bin(TimeGenerated, 1d), SubscriptionID
```

# Update resources

## Application Insights
### Disable IP Masking
az resource update --resource-group {RGName} --name {AppInsightsName} --resource-type "Microsoft.Insights/components" --set properties.DisableIpMasking=False