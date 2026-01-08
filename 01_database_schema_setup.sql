/*******************************************************************************
 * MEDPACE SPONSOR INSIGHTS AGENT - STEP 1: DATABASE & SCHEMA SETUP
 * 
 * Purpose: Initialize the database and schema infrastructure for the
 *          Sponsor Insights Agent backend.
 * 
 * Role: SF_INTELLIGENCE_DEMO
 * Date: December 2024
 ******************************************************************************/

-- Set the appropriate role for all operations
USE ROLE SF_INTELLIGENCE_DEMO;

-- Create the main database for Medpace clinical operations
CREATE DATABASE IF NOT EXISTS MEDPACE_DEMO
    COMMENT = 'Medpace clinical trial operations database containing structured metrics and unstructured protocol documents for the Sponsor Insights Agent.';

-- Create the schema for clinical operations data
CREATE SCHEMA IF NOT EXISTS MEDPACE_DEMO.CLINICAL_OPERATIONS
    COMMENT = 'Schema containing clinical trial enrollment metrics, site performance data, and protocol document chunks for AI-powered sponsor insights.';

-- Set the working context
USE SCHEMA MEDPACE_DEMO.CLINICAL_OPERATIONS;

-- Verify setup
SHOW SCHEMAS IN DATABASE MEDPACE_DEMO;

