CREATE TABLE [dbo].[AutoUnitAdditionalInterest] (
    [UnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                 INT           NOT NULL,
    [UnitNbr]                  INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [SublineBusinessTypeCd]    CHAR (1)      NOT NULL,
    [AdditionalInterestNbr]    CHAR (10)     NULL,
    [MortgageeLoanNbr]         CHAR (15)     NULL,
    [InterestDesc]             CHAR (30)     NULL,
    [ToTheAttentionOfNm]       VARCHAR (50)  NULL,
    [MortgageeSequenceNbr]     CHAR (3)      NULL,
    [AdditionalInterestAlt1Nm] VARCHAR (84)  NULL,
    [AdditionalInterestAlt2Nm] VARCHAR (84)  NULL,
    [AdditionalInterestAlt3Nm] CHAR (10)     NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([UnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoUnitAdditionalInterest_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoUnitAddtionalInterest_01]
    ON [dbo].[AutoUnitAdditionalInterest]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];

