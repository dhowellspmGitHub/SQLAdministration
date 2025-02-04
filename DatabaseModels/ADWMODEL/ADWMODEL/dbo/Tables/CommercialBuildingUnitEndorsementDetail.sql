CREATE TABLE [dbo].[CommercialBuildingUnitEndorsementDetail] (
    [PolicyId]                                  INT            NOT NULL,
    [CommercialBuildingUnitEndorsementDetailId] INT            NOT NULL,
    [UnitNbr]                                   INT            NOT NULL,
    [EndorsementId]                             INT            NOT NULL,
    [EndorsementNbr]                            CHAR (10)      NOT NULL,
    [LocationID]                                BIGINT         NULL,
    [PolicyNbr]                                 VARCHAR (16)   NOT NULL,
    [CashUnitNbr]                               CHAR (3)       NULL,
    [ItemNbr]                                   CHAR (3)       NOT NULL,
    [EndorsementLimitAmt]                       DECIMAL (9)    NOT NULL,
    [EndorsementPremiumAmt]                     DECIMAL (9, 2) NOT NULL,
    [CoveredPropertyDesc]                       VARCHAR (255)  NULL,
    [CoverageStartDt]                           DATE           NULL,
    [CoverageEndDt]                             DATE           NULL,
    [UtilitiesDesc]                             VARCHAR (255)  NULL,
    [UtilityTypeDesc]                           VARCHAR (255)  NULL,
    [CreatedTmstmp]                             DATETIME       NOT NULL,
    [UserCreatedId]                             CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                             DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                             CHAR (8)       NOT NULL,
    [LastActionCd]                              CHAR (1)       NOT NULL,
    [SourceSystemCd]                            CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [EndorsementNbr] ASC, [UnitNbr] ASC, [EndorsementId] ASC, [CommercialBuildingUnitEndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingUnitEndorsementDetail_CommercialBuildingUnitEndorsement_01] FOREIGN KEY ([PolicyId], [EndorsementNbr], [UnitNbr], [EndorsementId]) REFERENCES [dbo].[CommercialBuildingUnitEndorsement] ([PolicyId], [EndorsementNbr], [UnitNbr], [EndorsementId]),
    CONSTRAINT [FK_CommercialBuildingUnitEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingUnitEndorsementDetail_01]
    ON [dbo].[CommercialBuildingUnitEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

