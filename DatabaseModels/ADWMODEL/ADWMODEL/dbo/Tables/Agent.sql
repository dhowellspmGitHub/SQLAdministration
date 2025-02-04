﻿CREATE TABLE [dbo].[Agent] (
    [AgentId]                     INT           NOT NULL,
    [AgencyNbr]                   CHAR (3)      NOT NULL,
    [CountyNbr]                   CHAR (3)      NOT NULL,
    [BranchNbr]                   CHAR (3)      NOT NULL,
    [AgentNbr]                    CHAR (4)      NOT NULL,
    [SalesDistrictNbr]            CHAR (2)      NULL,
    [AgentTypeCd]                 CHAR (1)      NULL,
    [SFBAgentNbr]                 CHAR (5)      NULL,
    [AgentNm]                     CHAR (35)     NULL,
    [AgentPreferredNm]            CHAR (30)     NULL,
    [AgentInternalNm]             CHAR (30)     NULL,
    [AgentPlaqueNm]               CHAR (30)     NULL,
    [ManagerSequenceNbr]          CHAR (1)      NULL,
    [AddressLine1Desc]            VARCHAR (100) NULL,
    [AddressLine2Desc]            VARCHAR (100) NULL,
    [CityNm]                      CHAR (30)     NULL,
    [StateOrProvinceCd]           CHAR (3)      NULL,
    [ZipCd]                       CHAR (9)      NULL,
    [PhoneAreaCodeNbr]            CHAR (3)      NULL,
    [PhoneExchangeNbr]            CHAR (3)      NULL,
    [PhoneLocalNbr]               CHAR (4)      NULL,
    [PhoneNbr]                    CHAR (16)     NULL,
    [EmailAddressDesc]            VARCHAR (100) NULL,
    [ValidationPlanCd]            CHAR (5)      NULL,
    [ValidationInd]               CHAR (1)      NULL,
    [ValidationIndicatorDt]       DATE          NULL,
    [ValidationPopulationGroupCd] CHAR (3)      NULL,
    [SignsNbr]                    INT           NULL,
    [EquipmentInd]                CHAR (1)      NULL,
    [StartingDt]                  DATE          NULL,
    [PositionStartDt]             DATE          NULL,
    [KFBStartDt]                  DATE          NULL,
    [LicenseDt]                   DATE          NULL,
    [TerminationDt]               DATE          NULL,
    [TerminationReasonCd]         CHAR (4)      NULL,
    [AgentTransferDt]             DATE          NULL,
    [TransferAgentNbr]            CHAR (4)      NULL,
    [CurrentAgentNbr]             CHAR (4)      NULL,
    [AgentTransferInd]            CHAR (1)      NULL,
    [CurrentRecordInd]            BIT           NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_Agent] PRIMARY KEY CLUSTERED ([AgentId] ASC) ON [AGENCYCD],
    CONSTRAINT [FK_Agent_Agency_01] FOREIGN KEY ([AgencyNbr], [CountyNbr], [BranchNbr]) REFERENCES [dbo].[Agency] ([AgencyNbr], [CountyNbr], [BranchNbr])
) ON [AGENCYCD];


GO
CREATE NONCLUSTERED INDEX [IX_Agent_01]
    ON [dbo].[Agent]([AgencyNbr] ASC)
    ON [AGENCYCI];

