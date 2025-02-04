CREATE TABLE [dbo].[AdtnlIntIMAdtnlInt] (
    [AdditionalInterestId]             INT           NOT NULL,
    [CommercialIMAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                         INT           NOT NULL,
    [PolicyNbr]                        VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                    CHAR (8)      NOT NULL,
    [LastActionCd]                     CHAR (1)      NOT NULL,
    [SourceSystemCd]                   CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntIMAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [CommercialIMAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestIMAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestIMAdditionalInterest_CommercialIMAdditionalInterest_01] FOREIGN KEY ([CommercialIMAdditionalInterestId]) REFERENCES [dbo].[CommercialIMAdditionalInterest] ([CommercialIMAdditionalInterestId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AdtnlIntIMAdtnlInt_01]
    ON [dbo].[AdtnlIntIMAdtnlInt]([PolicyNbr] ASC)
    ON [POLICYCI];

