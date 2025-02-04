CREATE TABLE [dbo].[AdtnlIntAutoQuoteUnitAdtnlInt] (
    [AutoQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [AdditionalInterestId]              INT           NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntAutoQuoteUnitAdtnlInt] PRIMARY KEY CLUSTERED ([AutoQuoteUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdtnlIntAutoQuoteUnitAdtnlInt_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdtnlIntAutoQuoteUnitAdtnlInt_AutoQuoteUnitAdditionalInterest_01] FOREIGN KEY ([AutoQuoteUnitAdditionalInterestId]) REFERENCES [dbo].[AutoQuoteUnitAdditionalInterest] ([AutoQuoteUnitAdditionalInterestId])
) ON [POLICYCD];

