/*******************************************************************************
 * CRO SPONSOR INSIGHTS AGENT - STEP 1: DATABASE & SCHEMA SETUP
 * 
 * Purpose: Initialize the database and schema infrastructure for the
 *          Sponsor Insights Agent backend.
 * 
 * Role: SF_INTELLIGENCE_DEMO
 * Date: December 2024
 ******************************************************************************/

-- Set the appropriate role for all operations
USE ROLE SF_INTELLIGENCE_DEMO;

-- Create the main database for CRO clinical operations
CREATE DATABASE IF NOT EXISTS CRO_DEMO
    COMMENT = 'CRO clinical trial operations database containing structured metrics and unstructured protocol documents for the Sponsor Insights Agent.';

-- Create the schema for clinical operations data
CREATE SCHEMA IF NOT EXISTS CRO_DEMO.CLINICAL_OPERATIONS
    COMMENT = 'Schema containing clinical trial enrollment metrics, site performance data, and protocol document chunks for AI-powered sponsor insights.';

-- Set the working context
USE SCHEMA CRO_DEMO.CLINICAL_OPERATIONS;

-- Verify setup
SHOW SCHEMAS IN DATABASE CRO_DEMO;

