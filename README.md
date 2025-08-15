Goal. Forecast weekly US Google Trends at DMA level; detect spikes to mitigate forecast error during sudden surges.
Data. bigquery-public-data.google_trends.top_terms, filtered to US DMAs, last N years; engineered lags, seasonality, rolling stats, motion features.
Models.
* LightGBM regression for base forecast (best RMSE).
* Spike classifier (LightGBM + isotonic calibration) predicting spike at t+1 using only t features (shifted by 1 week) — no leakage.
Metrics. Report overall / stable / spike RMSE for forecasts; AUC/AP and P/R/F1 for spike classifier.
Inference. Use predict_spikes_next_week(df_panel) to get p_spike and is_spike_pred per (term, week).
Limitations. Without external signals (news/schedule releases), spikes remain hard; classifier helps gate adjustments but isn’t omniscient.
Future work. Add external event flags, release calendars, holiday/season effects, or per-category models.
