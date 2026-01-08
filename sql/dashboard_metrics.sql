-- AUC over time
SELECT score_date, auc
FROM mlops_project.monitoring_auc_daily
WHERE model_alias = 'Champion'
ORDER BY score_date;

-- PSI over time
SELECT score_date, psi_default_proba
FROM mlops_project.monitoring_drift_daily
WHERE model_alias = 'Champion'
ORDER BY score_date;

-- Default rate by score band
SELECT score_date, score_band, n, actual_default_rate, avg_pred_proba
FROM mlops_project.monitoring_score_bands_daily
WHERE model_alias = 'Champion'
ORDER BY score_date, score_band;
