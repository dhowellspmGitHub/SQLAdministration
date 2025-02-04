CREATE TABLE [dbo].[AdtnlIntAutoUnitAdtnlInt] (
    [AdditionalInterestId]     INT           NOT NULL,
    [UnitAdditionalInterestId] INT           NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntAutoUnitAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [UnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdtnlIntAutoUnitAdtnlInt_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdtnlIntAutoUnitAdtnlInt_AutoUnitAdditionalInterest_01] FOREIGN KEY ([UnitAdditionalInterestId]) REFERENCES [dbo].[AutoUnitAdditionalInterest] ([UnitAdditionalInterestId])
) ON [POLICYCD];

