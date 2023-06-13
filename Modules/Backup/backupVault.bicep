param location string  
param backupVaultName string  
param dailyBackupTime string  
param vmBackupPolicyName string  
param sqlBackupPolicyName string  
param dailyRetentionDays int  
param weeklyRetentionWeeks int  
param monthlyRetentionMonths int  
param yearlyRetentionYears int  
  
resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2016-06-01' = {  
  name: backupVaultName  
  location: location  
  sku: {  
    name: 'Standard'  
  }  
  properties: {  
    storageModelType: 'GeoRedundant'  
  }  
}  
  
resource vmBackupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2016-06-01' = {  
  parent: recoveryServicesVault
  name: vmBackupPolicyName
  location: location  
  properties: {  
    backupManagementType: 'AzureIaasVM'  
    schedulePolicy: {  
      schedulePolicyType: 'SimpleSchedulePolicy'  
      scheduleRunFrequency: 'Daily'  
      scheduleRunTimes: [  
        dailyBackupTime  
      ]  
    }  
    retentionPolicy: {  
      retentionPolicyType: 'LongTermRetentionPolicy'  
      dailySchedule: {  
        retentionDuration: {  
          count: dailyRetentionDays  
          durationType: 'Days'  
        }  
      }  
      weeklySchedule: {  
        retentionDuration: {  
          count: weeklyRetentionWeeks  
          durationType: 'Weeks'  
        }  
        daysOfTheWeek: [  
          'Sunday'  
        ]  
      }  
      monthlySchedule: {  
        retentionDuration: {  
          count: monthlyRetentionMonths  
          durationType: 'Months'  
        }  
        daysOfTheMonth: [  
          {  
            date: 1  
          }  
        ]  
      }  
      yearlySchedule: {  
        retentionDuration: {  
          count: yearlyRetentionYears  
          durationType: 'Years'  
        }  
        daysOfTheMonth: [  
          {  
            date: 1  
          }  
        ]  
        monthsOfYear: [  
          'January'  
        ]  
      }  
    }  
  }  
}  
  
resource sqlBackupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2016-06-01' = {  
  parent: recoveryServicesVault
  name: sqlBackupPolicyName  
  location: location  
  properties: {  
    backupManagementType: 'AzureWorkload'  
    workloadType: 'SQLDataBase'  
    schedulePolicy: {  
      schedulePolicyType: 'SimpleSchedulePolicy'  
      scheduleRunFrequency: 'Daily'  
      scheduleRunTimes: [  
        dailyBackupTime  
      ]  
    }  
    retentionPolicy: {  
      retentionPolicyType: 'LongTermRetentionPolicy'  
      dailySchedule: {  
        retentionDuration: {  
          count: dailyRetentionDays  
          durationType: 'Days'  
        }  
      }  
      weeklySchedule: {  
        retentionDuration: {  
          count: weeklyRetentionWeeks  
          durationType: 'Weeks'  
        }  
        daysOfTheWeek: [  
          'Sunday'  
        ]  
      }  
      monthlySchedule: {  
        retentionDuration: {  
          count: monthlyRetentionMonths  
          durationType: 'Months'  
        }  
        daysOfTheMonth: [  
          {  
            date: 1  
          }  
        ]  
      }  
      yearlySchedule: {  
        retentionDuration: {  
          count: yearlyRetentionYears  
          durationType: 'Years'  
        }  
        daysOfTheMonth: [  
          {  
            date: 1  
          }  
        ]  
        monthsOfYear: [  
          'January'  
        ]  
      }  
    }  
  }  
}  
  
output backupVaultId string = recoveryServicesVault.id  
