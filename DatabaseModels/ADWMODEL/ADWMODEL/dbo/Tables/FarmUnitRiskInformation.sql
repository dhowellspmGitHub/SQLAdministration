CREATE TABLE [dbo].[FarmUnitRiskInformation] (
    [PolicyId]                   INT            NOT NULL,
    [UnitNbr]                    INT            NOT NULL,
    [SequenceNbr]                CHAR (3)       NOT NULL,
    [UnitTypeCd]                 CHAR (1)       NOT NULL,
    [PolicyNbr]                  VARCHAR (16)   NOT NULL,
    [SourceSystemDisplayUnitNbr] INT            NULL,
    [CashUnitNbr]                CHAR (3)       NULL,
    [RatingFctr]                 DECIMAL (4, 3) NULL,
    [RateFieldNm]                VARCHAR (50)   NULL,
    [CreatedTmstmp]              DATETIME       NOT NULL,
    [UserCreatedId]              CHAR (8)       NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]              CHAR (8)       NOT NULL,
    [LastActionCd]               CHAR (1)       NOT NULL,
    [SourceSystemCd]             CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmUnitRiskInformation] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [SequenceNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitRiskInformation_FarmUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnit] ([PolicyId], [UnitNbr], [UnitTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitRiskInformation_01]
    ON [dbo].[FarmUnitRiskInformation]([PolicyId] ASC)
    ON [POLICYCI];

