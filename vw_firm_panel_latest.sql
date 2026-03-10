CREATE VIEW vw_firm_panel_latest AS
SELECT
    f.firm_id,
    f.ticker,
    snap.fiscal_year,

    own.managerial_inside_own,
    own.state_own,
    own.institutional_own,
    own.foreign_own,

    mar.shares_outstanding,

    fin.net_sales,
    fin.total_assets,
    fin.selling_expenses,
    fin.general_admin_expenses,
    fin.intangible_assets_net,
    fin.manufacturing_overhead,
    fin.net_operating_income,
    fin.raw_material_consumption,
    fin.merchandise_purchase_year,
    fin.wip_goods_purchase,
    fin.outside_manufacturing_expenses,
    fin.production_cost,
    fin.rnd_expenses,

    inno.product_innovation,
    inno.process_innovation,

    fin.net_income,
    fin.total_equity,

    mar.market_value_equity,

    fin.total_liabilities,

    cas.net_cfo,
    cas.capex,
    cas.net_cfi,

    fin.cash_and_equivalents,
    fin.long_term_debt,
    fin.current_assets,
    fin.current_liabilities,

    fin.growth_ratio,
    fin.inventory,

    mar.dividend_cash_paid,
    mar.eps_basic,

    fir.employees_count,

    fin.net_ppe,

    fir.firm_age

FROM dim_firm f

LEFT JOIN fact_financial_year fin
    ON f.firm_id = fin.firm_id

LEFT JOIN fact_data_snapshot snap
    ON fin.snapshot_id = snap.snapshot_id

LEFT JOIN fact_ownership_year own
    ON fin.firm_id = own.firm_id
    AND fin.snapshot_id = own.snapshot_id

LEFT JOIN fact_market_year mar
    ON fin.firm_id = mar.firm_id
    AND fin.snapshot_id = mar.snapshot_id

LEFT JOIN fact_cashflow_year cas
    ON fin.firm_id = cas.firm_id
    AND fin.snapshot_id = cas.snapshot_id

LEFT JOIN fact_innovation_year inno
    ON fin.firm_id = inno.firm_id
    AND fin.snapshot_id = inno.snapshot_id

LEFT JOIN fact_firm_year_meta fir
    ON fin.firm_id = fir.firm_id
    AND fin.snapshot_id = fir.snapshot_id;
