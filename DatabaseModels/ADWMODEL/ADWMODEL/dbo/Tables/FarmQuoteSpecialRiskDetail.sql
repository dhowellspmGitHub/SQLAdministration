CREATE TABLE [dbo].[FarmQuoteSpecialRiskDetail] (
    [QuoteNbr]                   VARCHAR (16)   NOT NULL,
    [FarmQuoteSpecialRiskId]     INT            NOT NULL,
    [SequenceNbr]                CHAR (3)       NOT NULL,
    [LocationID]                 BIGINT         NULL,
    [BoatLengthRangeNbr]         VARCHAR (50)   NULL,
    [BoatHorsePowerRangeNbr]     VARCHAR (50)   NULL,
    [PropulsionDesc]             VARCHAR (50)   NULL,
    [CoveragePremiumAmt]         DECIMAL (9, 2) NULL,
    [AcresNbr]                   INT            NULL,
    [LakeOrRecreationGroundsCnt] INT            NULL,
    [GravelPitCnt]               INT            NULL,
    [CreatedTmstmp]              DATETIME       NOT NULL,
    [UserCreatedId]              CHAR (8)       NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]              CHAR (8)       NOT NULL,
    [LastActionCd]               CHAR (1)       NOT NULL,
    [SourceSystemCd]             CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteSpecialRiskDetail] PRIMARY KEY CLUSTERED ([FarmQuoteSpecialRiskId] ASC, [QuoteNbr] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyQuoteSpecialRiskDetail_FarmPolicyQuoteSpecialRisk_01] FOREIGN KEY ([FarmQuoteSpecialRiskId], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteSpecialRisk] ([FarmQuoteSpecialRiskId], [QuoteNbr]),
    CONSTRAINT [FK_FarmQuoteSpecialRiskDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteSpecialRiskDetail_01]
    ON [dbo].[FarmQuoteSpecialRiskDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

